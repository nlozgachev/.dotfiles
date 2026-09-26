# .dotfiles

macOS developer configuration for [fish](https://fishshell.com), [git](https://git-scm.com), [helix](https://helix-editor.com), [tmux](https://github.com/tmux/tmux), [ghostty](https://ghostty.org), and [mise](https://mise.jdx.dev).

Unified with the **Tomorrow Night Blue** theme across all tools.

Managed with [stow](https://www.gnu.org/software/stow/) and [just](https://just.systems).

## Structure

```
configs/          stow packages — each mirrors ~/
├── fish/         fish shell
├── ghostty/      ghostty terminal
├── git/          git
├── helix/        helix editor (polyglot + oxfmt/oxlint + format on save)
├── mise/         mise tool configuration
└── tmux/         tmux
justfile          task runner
```

## Fresh machine setup

**1. Install Homebrew** (manual — nothing else is available yet)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. Install `just`**

```sh
brew install just
```

**3. Install packages, fonts, and symlink configs**

```sh
just setup
```

## Machine-specific config (not tracked in repo)

### Git identity

Create `~/.gitconfig-local` with your email and signing key:

```ini
[user]
    email = you@example.com
    signingkey = YOUR_GPG_KEY_FINGERPRINT
```

The tracked `.gitconfig` includes this file automatically via `[include]`.

### Fish local config

Create `~/.config/fish/local.fish` for per-machine settings: secrets, env vars, work-only tools.

```fish
# Example: work machine
set -gx SOME_API_KEY "..."
source ~/.asdf/plugins/java/set-java-home.fish
```

Loaded automatically at the end of `config.fish`. This file should never be committed.

## Languages & Development Tools

Installed via [mise](https://mise.jdx.dev) (Node, Deno, Go, Swift), [uv](https://docs.astral.sh/uv) (Python), and [rustup](https://rustup.rs) (Rust):

```sh
just node          # Node.js LTS + pnpm
just frontend      # oxlint, oxfmt, TypeScript LSP, web LSPs
just deno          # Deno
just go            # Go + gopls
just python        # Python (latest via uv) + ruff
just rust          # Rust (via rustup) + rust-analyzer
just langs         # all of the above
```

## Helix Editor

Configured for polyglot development with a VSCode-familiar experience:
- **Tomorrow Night Blue** theme.
- **Global format-on-save** (`oxfmt` for TS/JS/HTML/CSS/JSON/MD/YAML, `gopls` for Go, `ruff` for Python, `rustfmt` for Rust, `swift-format` for Swift, `jdtls` for Java, `taplo` for TOML).
- **Fast diagnostics**: `oxlint` LSP for instant JS/TS checks.
- **Mouse controls enabled**: click to position cursor, drag to select, scroll wheel.
- **Bufferline tabs**: open file tabs always displayed at the top.
- **Navigation shortcuts**:
  - `Ctrl+P`: Fuzzy open files (`file_picker`)
  - `Ctrl+S`: Save & format on save (both normal and insert mode)
  - `Alt+W`: Close current tab / buffer
  - `Tab` / `Shift+Tab`: Switch to next / previous buffer tab
  - `gn` / `gp`: Switch to next / previous buffer
  - `Ctrl+W` / `Space+W`: Window mode (splits: `v` vertical, `s` horizontal, `q` close)
  - `F12` / `gd`: Go to definition
  - `Ctrl+O`: Jump back in history
  - `Space+k` / `K`: Hover documentation
  - `Ctrl+C`: Toggle comments
  - `Alt+X`: Command palette

> **Full Tutorial & Cheatsheet**: See [HELIX_GUIDE.md](HELIX_GUIDE.md) for a comprehensive guide on modal editing, text objects (`mi"`), multi-cursors, and daily workflows.

## All tasks

```sh
just           # list all available tasks
```
