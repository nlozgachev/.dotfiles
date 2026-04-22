# .dotfiles

macOS developer configuration for [fish](https://fishshell.com), [git](https://git-scm.com), [helix](https://helix-editor.com), [tmux](https://github.com/tmux/tmux), [rio](https://rioterm.com), [zed](https://zed.dev), and [Claude Code](https://claude.ai/code).

Managed with [stow](https://www.gnu.org/software/stow/) and [just](https://just.systems).

## Structure

```
configs/          stow packages — each mirrors ~/
├── claude/       Claude Code settings
├── fish/         fish shell
├── git/          git
├── rio/          rio terminal
├── tmux/         tmux
└── zed/          zed editor
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

## Languages

Installed via [mise](https://mise.jdx.dev) (Node, Deno, Go) and [uv](https://docs.astral.sh/uv) (Python):

```sh
just node      # Node.js LTS + pnpm
just deno      # Deno
just go        # Go
just python    # Python (latest, via uv)
just rust      # Rust (via rustup)
just langs     # all of the above
```

## Claude Code

Install Claude Code and plugins:

```sh
just claude
```

This installs Claude Code via the official installer, then adds:
- **superpowers** — agentic workflows, TDD, debugging, planning skills
- **claude-mem** — cross-session persistent memory
- **caveman** — compressed communication mode

Claude config (`settings.json`) is tracked in `configs/claude/` and symlinked via stow.

> **Note:** If `~/.claude/settings.json` already exists, remove it before running `just link` so stow can create the symlink.

## All tasks

```sh
just           # list all available tasks
```
