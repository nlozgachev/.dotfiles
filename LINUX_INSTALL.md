# Void Linux Installation Guide
## LUKS2, btrfs, systemd-boot, and Sway on UEFI

* **Target architecture:** x86_64 UEFI
* **Core stack:** Void Linux (glibc), runit, LUKS2 with Argon2id, btrfs subvolumes, systemd-boot, Sway (Wayland)

---

## Partition Layout

| Device | Size | Type | Mount point | Filesystem / Format |
| :--- | :--- | :--- | :--- | :--- |
| `/dev/sda1` | 1 GiB | EFI System Partition | `/boot` | FAT32 (unencrypted) |
| `/dev/sda2` | Remainder | Linux filesystem | `/` | LUKS2 (Argon2id) → btrfs |

systemd-boot reads kernels and initramfs images directly from the EFI System Partition (ESP) mounted at `/boot`. A separate unencrypted `/boot` partition is unnecessary. LUKS2 encrypts the root filesystem container on `/dev/sda2`.

### btrfs Subvolume Structure

| Subvolume | Target mount point | Purpose |
| :--- | :--- | :--- |
| `@` | `/` | Root filesystem |
| `@home` | `/home` | User data |
| `@snapshots` | `/.snapshots` | Snapper root snapshots |
| `@var` | `/var` | System state and logs |
| `@var/cache/xbps` | `/var/cache/xbps` | Package cache (nested; excluded from `@` snapshots) |
| `@var/tmp` | `/var/tmp` | Temporary files (nested; excluded from `@` snapshots) |
| `@var/swap` | `/var/swap` | Swapfile storage (nested; excluded from `@` snapshots) |

btrfs does not recursively snapshot nested subvolumes. Creating dedicated subvolumes for `@var/cache/xbps`, `@var/tmp`, and `@var/swap` prevents transient data and swap allocations from inflating root snapshot sizes.

---

## Step 0: Live Environment Networking

Verify network interfaces and connectivity:

```sh
ip link
```

### Wired Connection
`dhcpcd` typically starts automatically on the live ISO. Verify link and address:

```sh
ip addr
ping -c 3 voidlinux.org
```

If not configured automatically:
```sh
dhcpcd <interface>
```

### Wireless Connection
```sh
ip link set <interface> up
wpa_passphrase "SSID" "password" > /tmp/wpa.conf
wpa_supplicant -B -i <interface> -c /tmp/wpa.conf
dhcpcd <interface>
```

---

## Step 1: Disk Partitioning

Verify the target disk identifier before writing changes:

```sh
lsblk
```

Wipe existing partition signatures:
```sh
wipefs -a /dev/sda
```

Partition disk with `fdisk`:
```sh
fdisk /dev/sda
```

Commands within `fdisk`:
1. `g`: Create a new GPT partition table.
2. `n`, default partition number (`1`), default first sector, `+1G`: Create 1 GiB EFI partition.
3. `t`, `1`: Set partition 1 type to `EFI System`.
4. `n`, default partition number (`2`), default first sector, default last sector: Allocate remaining disk space for LUKS.
5. `w`: Write partition table to disk.

If prompted to remove existing signatures, confirm with `Y`.

---

## Step 2: Format EFI System Partition

Format `/dev/sda1` as FAT32:

```sh
mkfs.vfat -F32 /dev/sda1
```

---

## Step 3: Configure LUKS2 Container (Argon2id)

Format `/dev/sda2` with LUKS2 and Argon2id key derivation:

```sh
cryptsetup luksFormat \
  --type luks2 \
  --cipher aes-xts-plain64 \
  --key-size 512 \
  --hash sha512 \
  --pbkdf argon2id \
  --pbkdf-memory 1048576 \
  --pbkdf-parallel 4 \
  --iter-time 5000 \
  /dev/sda2
```

Enter `YES` when prompted, then supply the encryption passphrase.

* Parameter details:
  * `--pbkdf argon2id`: Memory-hard key derivation function resistant to GPU and ASIC brute-force attacks.
  * `--pbkdf-memory 1048576`: Allocates 1 GiB of RAM for key derivation.
  * `--pbkdf-parallel 4`: Uses 4 threads for key derivation.
  * `--iter-time 5000`: Benchmarks key derivation to approximately 5 seconds.

Open the encrypted container:

```sh
cryptsetup open /dev/sda2 cryptroot
```

The decrypted mapper device is available at `/dev/mapper/cryptroot`.

---

## Step 4: Create btrfs Subvolumes

Format the decrypted container:

```sh
mkfs.btrfs -L void /dev/mapper/cryptroot
```

Mount top-level filesystem temporarily to construct subvolumes:

```sh
mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var

# Nested subvolumes
mkdir -p /mnt/@var/cache
btrfs subvolume create /mnt/@var/cache/xbps
btrfs subvolume create /mnt/@var/tmp
btrfs subvolume create /mnt/@var/swap

umount /mnt
```

---

## Step 5: Mount Subvolumes

Compression (`compress=zstd:1`) is omitted during install-time mounts. Setting compression properties on a subvolume causes kernel `NOCOW` ioctl operations to return `EINVAL`. Omitting compression at install time ensures `@var/swap` remains uncompressed for swapfile creation. Compression for general subvolumes is applied permanently in `/etc/fstab`.

```sh
BTRFS_OPTS="noatime,space_cache=v2,ssd,discard=async"
SWAP_OPTS="noatime,nodatacow,space_cache=v2,ssd,discard=async"

mount -o ${BTRFS_OPTS},subvol=@ /dev/mapper/cryptroot /mnt

mkdir -p /mnt/{boot,home,.snapshots,var}

mount -o ${BTRFS_OPTS},subvol=@home      /dev/mapper/cryptroot /mnt/home
mount -o ${BTRFS_OPTS},subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o ${BTRFS_OPTS},subvol=@var       /dev/mapper/cryptroot /mnt/var

mkdir -p /mnt/var/swap
mount -o ${SWAP_OPTS},subvol=@var/swap   /dev/mapper/cryptroot /mnt/var/swap

# Mount ESP directly at /boot
mount /dev/sda1 /mnt/boot
```

Mount option summary:
* `noatime`: Disables access-time updates on read operations.
* `nodatacow`: Disables copy-on-write, checksumming, and compression on the swap subvolume.
* `space_cache=v2`: Enables version 2 free-space cache.
* `discard=async`: Enables asynchronous queue trimming for SSDs.

---

## Step 6: Create Swapfile and Map Hibernation Offset

`btrfs filesystem mkswapfile` automatically sets the `NOCOW` (`C`) attribute. Do not run `btrfs property set compression none` on `@var/swap`, as setting a compression property applies the `m` (`NOCOMPRESS`) attribute, which conflicts with `NOCOW`.

```sh
btrfs filesystem mkswapfile --size 16G /mnt/var/swap/swapfile
swapon /mnt/var/swap/swapfile
swapon --show
```

Extract the physical swapfile offset required for kernel hibernation resume:

```sh
RESUME_OFFSET=$(btrfs inspect-internal map-swapfile -r /mnt/var/swap/swapfile)
echo "RESUME_OFFSET=${RESUME_OFFSET}"
```

Record the printed integer for Step 13.

If `mkswapfile` reports `cannot set NOCOW flag: invalid argument`:
```sh
lsattr -d /mnt/var/swap          # Inspect attributes for 'm'
chattr -m /mnt/var/swap          # Clear 'm' if set
btrfs filesystem mkswapfile --size 16G /mnt/var/swap/swapfile
```

---

## Step 7: Install Base System Packages

Copy cryptographic verification keys and DNS configuration into target:

```sh
mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/
mkdir -p /mnt/etc
cp /etc/resolv.conf /mnt/etc/
```

Install base packages using XBPS:

```sh
XBPS_ARCH=x86_64 xbps-install -S -r /mnt \
  -R https://repo-default.voidlinux.org/current \
  base-system \
  systemd-boot efibootmgr \
  cryptsetup \
  btrfs-progs \
  elogind dbus polkit \
  NetworkManager \
  linux linux-headers linux-firmware \
  nftables \
  sudo git curl wget vim
```

---

## Step 8: Enter Chroot Environment

Bind mount virtual filesystems:

```sh
for dir in dev proc sys run; do
  mount --rbind /$dir /mnt/$dir
  mount --make-rslave /mnt/$dir
done

chroot /mnt /bin/bash
```

---

## Step 9: System Configuration

### Timezone, Hostname, and Locale
```sh
ln -sf /usr/share/zoneinfo/Asia/Yerevan /etc/localtime
echo "voidbox" > /etc/hostname

echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
xbps-reconfigure -f glibc-locales
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### Hardware Clock and Keyboard
```sh
cat > /etc/rc.conf << 'EOF'
HARDWARECLOCK="UTC"
TIMEZONE="Asia/Yerevan"
KEYMAP="us"
EOF
```

### User Accounts and Sudo
```sh
# Root password
passwd

# User creation
useradd -m -G wheel,video,input,audio,storage,network -s /bin/bash youruser
passwd youruser

# Wheel group sudo configuration
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
```

---

## Step 10: Generate Filesystem Table (fstab)

Retrieve filesystem UUIDs:

```sh
EFI_UUID=$(blkid -s UUID -o value /dev/sda1)
ROOT_UUID=$(blkid -s UUID -o value /dev/mapper/cryptroot)

BTRFS_OPTS="noatime,compress=zstd:1,space_cache=v2,ssd,discard=async"
SWAP_OPTS="noatime,nodatacow,space_cache=v2,ssd,discard=async"

cat > /etc/fstab << EOF
# /boot (ESP)
UUID=${EFI_UUID}   /boot      vfat   defaults,noatime,umask=0077            0 2

# btrfs subvolumes (/dev/sda2 via cryptroot)
UUID=${ROOT_UUID}  /            btrfs  ${BTRFS_OPTS},subvol=@           0 1
UUID=${ROOT_UUID}  /home        btrfs  ${BTRFS_OPTS},subvol=@home       0 2
UUID=${ROOT_UUID}  /.snapshots  btrfs  ${BTRFS_OPTS},subvol=@snapshots  0 2
UUID=${ROOT_UUID}  /var         btrfs  ${BTRFS_OPTS},subvol=@var        0 2
UUID=${ROOT_UUID}  /var/swap    btrfs  ${SWAP_OPTS},subvol=@var/swap    0 2

# Swapfile
/var/swap/swapfile  none  swap  sw  0 0

# Hardened tmpfs
tmpfs  /tmp  tmpfs  defaults,nosuid,nodev,noexec  0 0
EOF
```

`umask=0077` restricts `/boot` access to root, protecting kernel and initramfs binaries.

---

## Step 11: Configure crypttab

Configure `/etc/crypttab` so the early initramfs prompts for passphrase decryption:

```sh
LUKS_UUID=$(blkid -s UUID -o value /dev/sda2)

cat > /etc/crypttab << EOF
cryptroot  UUID=${LUKS_UUID}  none  luks
EOF
```

Setting keyfile to `none` forces interactive passphrase entry at boot.

---

## Step 12: Configure dracut and Generate initramfs

Enable required modules in dracut:

```sh
cat > /etc/dracut.conf.d/crypt.conf << 'EOF'
hostonly=yes
add_dracutmodules+=" crypt btrfs resume "
install_items+=" /etc/crypttab "
EOF
```

Generate the initial ramdisk for the installed kernel:

```sh
KVER=$(ls /lib/modules | sort -V | tail -1)
dracut --force --hostonly --kver ${KVER}
```

---

## Step 13: Bootloader Setup (systemd-boot)

`bootctl install` fails inside a chroot environment because udev cannot verify the partition GUID. Install the EFI binary manually and write the NVRAM boot entry using `efibootmgr`:

```sh
mkdir -p /boot/EFI/systemd /boot/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /boot/EFI/systemd/systemd-bootx64.efi
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /boot/EFI/BOOT/BOOTX64.EFI

efibootmgr --create \
  --disk /dev/sda \
  --part 1 \
  --loader '\EFI\systemd\systemd-bootx64.efi' \
  --label "Void Linux" \
  --unicode
```

Configure `loader.conf`:
```sh
cat > /boot/loader/loader.conf << 'EOF'
default void.conf
timeout 3
console-mode max
editor no
EOF
```
`editor no` prevents command-line parameter modification at the boot prompt.

Create the bootloader entry:
```sh
KVER=$(ls /lib/modules | sort -V | tail -1)
LUKS_UUID=$(blkid -s UUID -o value /dev/sda2)
RESUME_OFFSET=$(btrfs inspect-internal map-swapfile -r /var/swap/swapfile)

mkdir -p /boot/loader/entries

cat > /boot/loader/entries/void.conf << EOF
title   Void Linux
linux   /vmlinuz-${KVER}
initrd  /intel-ucode.img
initrd  /initramfs-${KVER}.img
options rd.luks.uuid=${LUKS_UUID} rd.luks.name=${LUKS_UUID}=cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ resume=/dev/mapper/cryptroot resume_offset=${RESUME_OFFSET} rw quiet loglevel=3
EOF
```

---

## Step 14: Install Intel Microcode

Enable the nonfree repository and install CPU microcode:

```sh
xbps-install -S void-repo-nonfree
xbps-install intel-ucode
xbps-reconfigure -fa
```

---

## Step 15: Enable runit Services

In Void Linux, runit services are activated by creating symlinks in `/var/service/`:

```sh
# Desktop dependencies
ln -s /etc/sv/dbus           /var/service/
ln -s /etc/sv/elogind        /var/service/
ln -s /etc/sv/polkitd        /var/service/

# NetworkManager and firewall
ln -s /etc/sv/NetworkManager /var/service/
ln -s /etc/sv/nftables       /var/service/

# Disable standalone dhcpcd to prevent conflicting DHCP daemons
rm -f /var/service/dhcpcd 2>/dev/null || true
```

---

## Step 16: Configure nftables Firewall

Write baseline stateful firewall configuration:

```sh
cat > /etc/nftables.conf << 'EOF'
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        ct state established,related accept
        iif lo accept
        ct state invalid drop

        ip protocol icmp accept
        ip6 nexthdr icmpv6 accept
    }

    chain forward {
        type filter hook forward priority 0; policy drop;
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}
EOF
```

---

## Step 17: Security Hardening

Lock the root account to enforce sudo usage:

```sh
passwd -l root
echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su
```

Configure selective passwordless sudo, requiring authentication only for destructive commands:

```sh
cat > /etc/sudoers.d/wheel << 'EOF'
Cmnd_Alias DESTRUCTIVE = /usr/bin/rm, /usr/bin/dd, /usr/bin/shred, \
    /usr/bin/wipefs, /usr/bin/mkfs.btrfs, /usr/bin/mkfs.vfat, \
    /usr/bin/fdisk, /usr/bin/gdisk, /usr/bin/parted, \
    /usr/sbin/cryptsetup

%wheel ALL=(ALL:ALL) NOPASSWD: ALL, PASSWD: DESTRUCTIVE
EOF
chmod 440 /etc/sudoers.d/wheel
```

---

## Step 18: Exit Chroot and Reboot

Unmount filesystems and close the encrypted device:

```sh
exit

swapoff -a
umount -R /mnt
cryptsetup close cryptroot
reboot
```

At the initial boot prompt, dracut will prompt for the LUKS passphrase configured in Step 3.

---

## Step 19: Verification Post-Reboot

Check core subsystems after first boot:

```sh
# Verify active LUKS container
cryptsetup status cryptroot

# Verify btrfs subvolumes and mount options
findmnt -t btrfs

# Verify swapfile and NOCOW attribute
swapon --show
lsattr /var/swap/swapfile

# Verify bootloader entry and hibernation offsets
grep resume /boot/loader/entries/void.conf
bootctl status

# Verify microcode
dmesg | grep -i microcode

# Verify services and firewall
sv status dbus elogind polkitd NetworkManager nftables
nft list ruleset

# Verify fstab consistency
findmnt --verify
```

Expected checks:
* `cryptsetup status cryptroot`: active, cipher `aes-xts-plain64`, keysize `512`.
* `findmnt -t btrfs`: `@` subvolumes show `compress=zstd:1`; `/var/swap` shows `nodatacow`.
* `lsattr /var/swap/swapfile`: contains the `C` (NOCOW) flag.
* `dmesg | grep -i microcode`: reports microcode updated early.

---

## Step 20: Graphical Stack (Sway / Wayland)

Install desktop packages:

```sh
sudo xbps-install \
  sway waybar foot \
  pipewire wireplumber alsa-pipewire \
  wl-clipboard \
  xdg-utils xdg-user-dirs \
  xdg-desktop-portal xdg-desktop-portal-wlr \
  mesa-dri \
  fontconfig \
  neovim tmux zsh \
  grim slurp \
  swaylock swayidle \
  mako \
  fuzzel \
  snapper

chsh -s /bin/zsh youruser
```

### Environment Configuration (`~/.zprofile`)
Set required Wayland environment variables:

```sh
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export WAYLAND_DISPLAY=wayland-1
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland

# Auto-start Sway on tty1 login
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi
```

### Audio Daemons (Add to `~/.config/sway/config`)
```text
exec pipewire
exec pipewire-pulse
exec wireplumber
```

---

## Step 21: Snapshot Management (Snapper)

Initialize Snapper configurations for `/` and `/home`:

```sh
sudo snapper -c root create-config /
sudo snapper -c home create-config /home
```

### Manual Rollback Procedure
If a package upgrade causes system failure:

```sh
sudo snapper -c root list
sudo snapper -c root rollback <snapshot_number>
reboot
```

### Snapshot Pruning
```sh
sudo snapper -c root list
sudo snapper -c root delete <number>
sudo snapper -c root delete <start_number>-<end_number>
```

---

## Step 22: Hibernation Validation

Test hibernation to disk:

```sh
echo disk | sudo tee /sys/power/state
```

The system will suspend RAM to `/var/swap/swapfile` and power down. Upon power-on, the bootloader resumes execution directly into the desktop session.

### Hardware-Specific Workaround: Intel i915 GPU Kernel Panic
On certain Intel platforms (such as Dell Latitude 5490/7490), power state transitions during hibernation can trigger an i915 GPU kernel panic (indicated by a flashing Caps Lock LED).

Add the following parameter to the `options` line in `/boot/loader/entries/void.conf`:

```text
i915.enable_dc=0
```

If instability continues:
```text
i915.enable_psr=0 mem_sleep_default=deep intel_idle.max_cstate=1
```

Keep device firmware updated:
```sh
sudo xbps-install fwupd
sudo fwupdmgr refresh
sudo fwupdmgr update
```

---

## System Maintenance

Void Linux is an independently developed rolling release. Review the news feed before performing system upgrades:
```text
https://voidlinux.org/news/
```

### Helper Scripts

#### `/usr/local/bin/update-boot`
Void does not automatically regenerate `systemd-boot` entries when new kernels are installed. This script updates the boot entry and rebuilds the initramfs:

```sh
sudo tee /usr/local/bin/update-boot << 'EOF'
#!/bin/sh
set -e
KVER=$(ls /lib/modules | sort -V | tail -1)
LUKS_UUID=$(blkid -s UUID -o value /dev/sda2)
RESUME_OFFSET=$(btrfs inspect-internal map-swapfile -r /var/swap/swapfile)

tee /boot/loader/entries/void.conf << CONF
title   Void Linux
linux   /vmlinuz-${KVER}
initrd  /intel-ucode.img
initrd  /initramfs-${KVER}.img
options rd.luks.uuid=${LUKS_UUID} rd.luks.name=${LUKS_UUID}=cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ resume=/dev/mapper/cryptroot resume_offset=${RESUME_OFFSET} rw quiet loglevel=3
CONF

dracut --force --hostonly --kver ${KVER}
echo "Boot entry updated: kernel ${KVER}, resume_offset ${RESUME_OFFSET}"
EOF
sudo chmod +x /usr/local/bin/update-boot
```

#### `/usr/local/bin/sysupdate`
Unified system upgrade wrapper that snapshots the root filesystem, upgrades packages, and refreshes the bootloader:

```sh
sudo tee /usr/local/bin/sysupdate << 'EOF'
#!/bin/sh
set -e
snapper -c root create --description "pre-update $(date +%F)"
xbps-install -Su
update-boot
EOF
sudo chmod +x /usr/local/bin/sysupdate
```

Run upgrades with:
```sh
sudo sysupdate
```

### Service Management Reference
```sh
sv status <service>     # Check state
sv start <service>      # Start service
sv stop <service>       # Stop service
sv restart <service>    # Restart service

ln -s /etc/sv/<service> /var/service/  # Enable service on boot
rm /var/service/<service>              # Disable service
```

---

## Recovery: Recreating the Swapfile from a Live Environment

If the swapfile header is corrupted or needs re-allocation:

```sh
# 1. Unlock LUKS container
cryptsetup open /dev/sda2 cryptroot

# 2. Mount top-level btrfs volume
mkdir -p /mnt/btrfs
mount -o subvolid=5 /dev/mapper/cryptroot /mnt/btrfs

# 3. Check and clear NOCOMPRESS flag if present
lsattr -d /mnt/btrfs/@var/swap
chattr -m /mnt/btrfs/@var/swap

# 4. Re-allocate swapfile
mkdir -p /mnt/swap
mount -o noatime,nodatacow,subvol=@var/swap /dev/mapper/cryptroot /mnt/swap
rm -f /mnt/swap/swapfile
btrfs filesystem mkswapfile --size 16G /mnt/swap/swapfile
swapon /mnt/swap/swapfile

# 5. Extract updated physical offset
RESUME_OFFSET=$(btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile)
echo "RESUME_OFFSET=${RESUME_OFFSET}"

# 6. Update bootloader entry with new offset
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

LUKS_UUID=$(blkid -s UUID -o value /dev/sda2)
KVER=$(ls /mnt/btrfs/@/lib/modules | sort -V | tail -1)

cat > /mnt/boot/loader/entries/void.conf << EOF
title   Void Linux
linux   /vmlinuz-${KVER}
initrd  /intel-ucode.img
initrd  /initramfs-${KVER}.img
options rd.luks.uuid=${LUKS_UUID} rd.luks.name=${LUKS_UUID}=cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ resume=/dev/mapper/cryptroot resume_offset=${RESUME_OFFSET} rw quiet loglevel=3
EOF

# 7. Unmount and reboot
swapoff -a
umount /mnt/swap /mnt/boot /mnt/btrfs
cryptsetup close cryptroot
reboot
```
