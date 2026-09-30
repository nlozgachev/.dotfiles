# .dotfiles

A terminal-first development setup built to replace heavy IDEs with fast, keyboard-driven tools.


## The Stack

* **[Kitty](https://sw.kovidgoyal.net/kitty/)**: Terminal emulator.
* **[Fish](https://fishshell.com/)**: Shell with autosuggestions and completions.
* **[Zellij](https://zellij.dev/)**: Terminal multiplexer (tabs, panes, sessions).
* **[Helix](https://helix-editor.com/)**: Modal text editor with built-in LSP support.
* **[GitUI](https://github.com/extrawurst/gitui)**: Terminal UI for git staging, diffs, and commits.
* **[dprint](https://dprint.dev/)**: Fast, pluggable code formatter.
* **[Mise](https://mise.jdx.dev/)**: Runtime and tool version manager (Node, Go, Deno).
* **[GNU Stow](https://www.gnu.org/software/stow/)**: Symlink manager for dotfiles.
* **[just](https://just.systems/)**: Command runner for setup and maintenance.


## Structure

```
configs/      stow packages — each mirrors ~/
├── dprint/
├── fish/
├── git/
├── gitui/
├── helix/
├── kitty/
├── mise/
└── zellij/
justfile      task runner & bootstrap recipes
```


## Fresh Machine Setup

**1. Install Homebrew** (manual — nothing else is available yet):
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. Install `just`**:
```sh
brew install just
```

**3. Install packages, fonts, zjstatus plugin, and symlink configs**:
```sh
just setup
```

**4. Install language toolchains & LSPs**:
```sh
just langs
```

---

## Languages & Toolchains

Runtimes and language servers are managed via **[mise](https://mise.jdx.dev)**, **[uv](https://docs.astral.sh/uv)**, **[rustup](https://rustup.rs)**, and **npm**:

```sh
just node          # Node.js LTS + pnpm (via mise)
just frontend      # dprint, oxlint, TypeScript, vtsls, web & Astro LSPs (via npm)
just deno          # Deno (via mise)
just go            # Go + gopls (via mise)
just python        # Python (latest via uv) + ruff & pyright
just rust          # Rust (via rustup) + rust-analyzer
just langs         # Install all of the above
```

---

## CLI Shortcuts

Common shortcuts configured in Fish:

| Command | Action | Description |
| :--- | :--- | :--- |
| `ws` | Workspace | Resumes most recent Zellij session (or starts default layout) |
| `ws <name>` | Named Workspace | Attaches to or creates named workspace session |
| `ws ls` | List Workspaces | Lists active sessions |
| `ws k <name>`| Kill Workspace | Terminates a workspace session |
| `ed <path>` | Editor | Launches `$EDITOR` (Helix) |
| `gg` | Git UI | Launches GitUI in current folder |
| `md <file>` | Markdown View | Renders Markdown with inline images (`mdcat`) |

Package manager abbreviations expand in-place:
* `pn` → `pnpm`
* `pnd` → `pnpm dev`
* `pns` → `pnpm storybook`
* `pnt` → `pnpm test:dev`

---

## Machine-Specific Config (Untracked)

### Git Identity
Create `~/.gitconfig-local` with your email and signing key:
```ini
[user]
    email = you@example.com
    signingkey = YOUR_GPG_KEY_FINGERPRINT
```
Included automatically by `.gitconfig`.

### Fish Local Config
Create `~/.config/fish/local.fish` for machine-specific environment variables or work secrets:
```fish
set -gx SOME_API_KEY "..."
```
Loaded automatically at the end of `config.fish`.

---

## Tasks

```sh
just           # List all available recipes
just update    # Update homebrew, mise, tools, rust, and LSPs
```
