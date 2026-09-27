# Terminal Development Setup: Ghostty + Tmux + Helix + GitUI + Fish

A reference guide for working in a terminal development environment using Ghostty, Tmux, Helix, GitUI, and Fish.

---

## 1. Architecture & Tool Roles

```
┌─────────────────────────────────────────────────────────────┐
│                 Ghostty (Terminal Emulator)                 │
│  └─ Window management, font rendering, macOS key shortcuts  │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│           Tmux (Persistent Sessions, Windows, Splits)       │
│  ├─ Window 1: "editor"                                      │
│  │   ├─ Pane 1: Helix Editor (vtsls + oxlint + oxfmt)       │
│  │   ├─ Pane 2: GitUI                                       │
│  │   └─ Pane 3: Fish Shell                                  │
│  ├─ Window 2: "servers" (Dev Server, Watchers, Logs)        │
│  └─ Window 3: "git"     (Full-Screen Git Operations)        │
└─────────────────────────────────────────────────────────────┘
```

| Component | Tool | Role | VSCode Equivalent |
| :--- | :--- | :--- | :--- |
| **Terminal Emulator** | **Ghostty** | Window display, font rendering, macOS shortcut bridging | VSCode application window |
| **Workspace Multiplexer** | **Tmux** | Persistent sessions, window tabs, pane splits | Editor splits, layout management, terminal panel |
| **Editor** | **Helix** | Code editing, syntax highlighting, LSP client, formatting | Editor pane, Monaco editor, LSP extensions |
| **Git Client** | **GitUI** | Staging, diff inspection, commit history, branches | Source Control view, diff editor |
| **Shell** | **Fish** | Interactive shell, completions, package manager aliases | Integrated terminal shell |

---

## 2. Tmux: Sessions, Windows, and Panes

Prefix key:
```
Ctrl + a
```

### 1. Sessions
Sessions represent independent workspaces that persist in the background.

| Action | Shortcut / Command | Description |
| :--- | :--- | :--- |
| **New session** | `tmux new -s <name>` | Create a named session |
| **Detach** | `Ctrl + a` then `d` | Detach and leave session running |
| **List sessions** | `tmux ls` | List active sessions |
| **Attach** | `tmux attach -t <name>` | Reconnect to an existing session |
| **Kill session** | `tmux kill-session -t <name>` | Terminate a session |

### 2. Windows
Windows function as tabs across the status line.

| Action | Shortcut | Description |
| :--- | :--- | :--- |
| **New window** | `Ctrl + a` then `c` | Create a new window |
| **Rename window** | `Ctrl + a` then `,` | Rename current window |
| **Go to window N** | `Ctrl + a` then `1` / `2` / `3` | Switch directly to window by index |
| **Next / Prev window** | `Ctrl + a` then `n` / `p` | Cycle to next or previous window |
| **Close window** | `Ctrl + a` then `&` | Close current window |

### 3. Panes
Panes split the active window into multiple terminal regions.

| Action | Shortcut | Description |
| :--- | :--- | :--- |
| **Split vertical** | `Ctrl + a` then `\|` | Split pane left and right |
| **Split horizontal** | `Ctrl + a` then `-` | Split pane top and bottom |
| **Navigate panes** | `Ctrl + a` then `h` / `j` / `k` / `l` | Move focus left, down, up, or right |
| **Toggle zoom** | `Ctrl + a` then `z` | Maximize current pane (press again to restore) |
| **Cycle layouts** | `Ctrl + a` then `Space` | Switch between tiling arrangements |
| **Resize pane** | Drag border with mouse | Mouse mode is enabled (`set -g mouse on`) |
| **Close pane** | `Ctrl + d` or `exit` | Close active pane |

### 4. Typical 3-Pane Layout

```
┌───────────────────────────────────────┬────────────────────────┐
│                                       │  Top-Right (25%):      │
│                                       │  Dev Server / Watcher  │
│  Left Pane (75%):                     │  $ pnd                 │
│  Helix Editor                         ├────────────────────────┤
│                                       │  Bottom-Right (25%):   │
│                                       │  GitUI or Fish Shell   │
│                                       │  $ gui                 │
└───────────────────────────────────────┴────────────────────────┘
```

---

## 3. GitUI: Terminal Git Interface

Launch by running:
```sh
gui
```
*(Aliased to `gitui` in `configs/fish/.config/fish/config/set_aliases.fish`)*

### Views
Switch between views using **`1`**, **`2`**, **`3`**, **`4`** (or `Tab` / `Shift + Tab`):

1. **`Status` (1)**: Modified and untracked files, hunk review, staging.
2. **`Log` (2)**: Commit history, commit details, branch graph.
3. **`Files` (3)**: Repository file tree at `HEAD`.
4. **`Stashing` (4)**: Stash list, diff preview, apply, and drop.

### Keybindings

| Action | Key | Description |
| :--- | :--- | :--- |
| **Stage / Unstage File** | `s` / `u` | Stage or unstage selected file |
| **Stage All** | `a` | Stage all unstaged changes |
| **Discard Changes** | `D` *(Shift + d)* | Discard modifications in selected file or hunk |
| **Commit** | `c` | Open commit dialog |
| **Amend** | `c` then toggle amend | Amend previous commit |
| **Push** | `p` | Push commits to remote branch |
| **Pull** | `P` *(Shift + p)* | Pull commits from remote |
| **Fetch** | `f` | Fetch remote references |
| **Branch Menu** | `b` | Open branch list (switch or create) |
| **Tag Menu** | `t` | Open tag management |
| **Help** | `?` | Show interactive keybinding reference |
| **Quit** | `q` | Exit GitUI back to shell |

### Staging Line by Line
1. In the **Status** view (`1`), select a modified file.
2. Press `Enter` to focus the diff viewer.
3. Navigate to lines or hunks using `j` and `k`.
4. Press `s` to stage the selected line/hunk, or `u` to unstage.
5. Press `Esc` to return focus to the file list.

---

## 4. Helix Editor

### 1. Selection-First Editing Model
Helix evaluates selections before applying actions:
1. `w` selects the next word.
2. `d` deletes the selection, or `c` deletes it and enters Insert mode.

The cursor always represents an active selection of at least one character.

### 2. Modes

| Mode | Status Line | How to Enter | How to Exit |
| :--- | :--- | :--- | :--- |
| **Normal** | `NOR` | `Esc` | `i`, `a`, `c`, `v` |
| **Insert** | `INS` | `i` (before selection), `a` (after selection) | `Esc` |
| **Select** | `SEL` | `v` | `v` or `Esc` |

### 3. Motion & Navigation
* `h`, `j`, `k`, `l`: Move left, down, up, right.
* `w` / `b` / `e`: Move to next word start, previous word start, word end.
* `x`: Select current line (repeat to extend selection line by line).
* `gh` / `gl` / `gs`: Move to line start, line end, first non-whitespace character.
* `gg`: Jump to first line of file.
* `ge`: Jump to last line of file.
* `:123` then `Enter`: Jump to line 123.
* `Ctrl + d` / `Ctrl + u`: Scroll half-page down / up.

### 4. Opening Lines at File Boundaries
* **Start of file**: Press `gg` then `O` *(capital O)*. Jumps to the top, inserts a blank line above line 1, and enters Insert mode.
* **End of file**: Press `ge` then `o` *(lowercase o)*. Jumps to the bottom, inserts a blank line below the last line, and enters Insert mode.

### 5. Editing Actions
* `i` / `a`: Insert before / after selection.
* `I` / `A`: Insert at line start / line end.
* `o` / `O`: Open new line below / above current line and enter Insert mode.
* `c`: Change selection (deletes selection and enters Insert mode).
* `d`: Delete selection.
* `y` / `p` / `P`: Yank (copy), paste after, paste before.
* `u` / `U`: Undo / Redo.
* `>` / `<`: Indent / unindent selected lines.

### 6. Text Objects & Surround (`m`)
Match mode operates on enclosed delimiters:

| Key | Target | Example |
| :--- | :--- | :--- |
| `mi"` / `ma"` | Inside / Around double quotes | `"hello"` → `hello` / `"hello"` |
| `mi'` / `ma'` | Inside / Around single quotes | `'token'` → `token` / `'token'` |
| `mi(` / `ma(` | Inside / Around parentheses | `(a, b)` → `a, b` / `(a, b)` |
| `mi{` / `ma{` | Inside / Around braces | `{ id }` → ` id ` / `{ id }` |
| `mif` / `maf` | Inside / Around function body | Function implementation block |

* **Surround selection**: Select text, then press `ms"` (surrounds with `"..."`) or `ms(` (surrounds with `(...)`).
* **Replace surround**: Place cursor inside quoted string, then press `mr"'` (replaces `"` with `'`).
* **Delete surround**: Place cursor inside quoted string, then press `md"` (removes quotes).

### 7. Multi-Cursor Selection
* **Regex select (`s`)**: Select a block (e.g. `x` or whole buffer `%`), press `s`, type a pattern, and press `Enter`. Each match receives an active cursor. Edit with `c` or `d`. Press `,` (comma) to remove extra cursors.
* **Add cursor below (`C`)**: Press `C` *(capital C)* to add a cursor on the next line.
* **Split into lines (`Alt + s`)**: Splits a multi-line selection into one cursor per line.

### 8. Language Server & Formatting
* **Go to Definition**: `F12` (or `gd`). Return with `Ctrl + o`.
* **Find References**: `Shift + F12` (or `gr`).
* **Hover / Type Info**: `Space + k` (or `K`).
* **Inlay Hints**: Types and parameter names display inline automatically (`vtsls`).
* **Code Actions**: `Space + a`.
* **Diagnostics**:
  * File diagnostics: `Space + d`
  * Workspace diagnostics: `Space + D`
  * Next / previous diagnostic: `]d` / `[d`
* **Rename Symbol**: `F2` (or `Space + r`), type new name, press `Enter`. Save modified buffers with `:wa`.
* **Format**: `Cmd + S` (or `:format`), formatted via `oxfmt`.

---

## 5. Opening Links and URLs

Terminal applications with mouse capture enabled intercept standard clicks. To open URLs:

* **Helix (`gf`)**: Place the cursor anywhere on the URL and press `gf` (goto_file). Helix opens the address in your default browser.
* **Ghostty (`Shift + Click`)**: Hold `Shift` (or `Cmd + Shift`) while clicking the link to bypass terminal mouse capture.

---

## 6. Action Reference: VSCode to Terminal

| Action / Feature | VSCode | Terminal Equivalent | Details |
| :--- | :--- | :--- | :--- |
| **File Picker** | `Cmd + P` | `Cmd + P` / `Ctrl + p` / `Space + f` | Fuzzy search files by path or name |
| **Create File** | Context menu → New File | `:open src/path/file.ts` | Opens buffer; directory path is created on save |
| **Save & Format** | `Cmd + S` | `Cmd + S` / `Ctrl + s` / `:w` | Writes buffer and formats with `oxfmt` |
| **Hover Information** | Mouse hover, `Cmd + K Cmd + I` | `Space + k` / `K` | Shows type signature and documentation |
| **Inlay Hints** | Settings toggle | Displayed inline | Parameter names and return types via `vtsls` |
| **Project Search** | `Cmd + Shift + F` | `Cmd + Shift + F` / `Space + /` | Live ripgrep search across workspace |
| **Workspace Symbols** | `Cmd + T` | `Space + S` | Search classes, interfaces, and functions |
| **Document Outline** | `Cmd + Shift + O` | `Space + s` | List symbols in current buffer |
| **Problems Panel** | `Cmd + Shift + M` | `Space + d` / `Space + D` | File diagnostics (`Space + d`), workspace (`Space + D`) |
| **Next / Prev Diagnostic** | `F8` / `Shift + F8` | `]d` / `[d` | Jump directly to next/previous error |
| **Code Actions** | `Cmd + .` | `Space + a` | Quick fixes, imports, lint rules |
| **Go to Definition** | `F12` | `F12` / `gd` | Jump to definition (`Ctrl + o` to return) |
| **Find References** | `Shift + F12` | `Shift + F12` / `gr` | List symbol references in fuzzy picker |
| **Rename Symbol** | `F2` | `F2` / `Space + r` | Rename across project; save all with `:wa` |
| **Multi-Cursor Next Match** | `Cmd + D` | `x` → `s` → `Enter` | Select lines, press `s`, type pattern, edit with `c` |
| **Multi-Cursor Add Below** | `Option + Click` | `C` | Place cursor on next line |
| **Surround Text** | Type delimiter on selection | `ms"` / `ms(` | Wrap selection in quotes or brackets |
| **Toggle Line Comment** | `Cmd + /` | `Cmd + /` / `Ctrl + c` / `Space + c` | Toggle comment on line or selection |
| **Toggle Block Comment** | `Option + Shift + A` | `Space + C` | Wrap selection in `/* ... */` |
| **Git Status & Staging** | `Cmd + Shift + G` | `gui` (GitUI) | Visual staging, diffs, commits |
| **Next / Prev Git Diff** | Gutter click | `]g` / `[g` | Jump to next or previous modified hunk |
| **Terminal Drawer** | `Ctrl + ` ` / `Cmd + J` | `Ctrl + a` then `-` / `Ctrl + z` | Split pane in Tmux, or suspend Helix with `Ctrl + z` |
| **Buffer Switching** | Click tabs, `Cmd + Option + Left/Right` | `Tab` / `Shift + Tab` / `Space + b` | `Tab`/`S-Tab` cycles buffers; `Space + b` searches by name |
| **Close Buffer** | `Cmd + W` | `Alt + w` / `:bc` | Close current buffer (`:bc!` force closes) |
| **Command Palette** | `Cmd + Shift + P` | `Cmd + Shift + P` / `Alt + x` / `Space + ?` | Searchable command palette |
| **Open URL** | `Cmd + Click` | `gf` / `Shift + Click` | `gf` on link in Helix, or `Shift + Click` in Ghostty |

---

## 7. macOS Shortcuts & Ergonomics

### 1. Ghostty `Cmd` Shortcuts
Configured in `configs/ghostty/.config/ghostty/config` to map standard macOS `Cmd` combinations to Helix actions:
* `Cmd + S`: Save buffer (`:w`)
* `Cmd + P`: File picker (`Space + f`)
* `Cmd + /`: Toggle line comment (`Space + c`)
* `Cmd + Shift + P`: Command palette (`Space + ?`)
* `Cmd + Shift + F`: Global search (`Space + /`)

### 2. Space Leader Key
Most Helix commands begin with `Space`, keeping actions reachable without modifying key combinations:
* `Space + f`: File picker
* `Space + /`: Global search
* `Space + ?`: Command palette
* `Space + b`: Buffer switcher
* `Space + c`: Toggle comment
* `Space + a`: Code actions
* `Space + k`: Hover information

### 3. Remapping Caps Lock to Control
For shortcuts that use `Ctrl` (`Ctrl + a` in Tmux, `Ctrl + o` jump back, `Ctrl + d` scroll):
1. Open **macOS System Settings** → **Keyboard** → **Keyboard Shortcuts…** → **Modifier Keys**.
2. Set **Caps Lock Key** to **Control**.

---

## 8. Common Workflows

### Persistent Session Management
```sh
# Start or reconnect to a project session
tmux attach -t my-app || tmux new -s my-app

# Detach from session (leaves processes running)
Ctrl + a then d
```

### Git Staging and Committing
1. Open GitUI in a pane or window: `gui`
2. In the **Status** view (`1`), select a file and press `Enter` to review the diff.
3. Stage specific lines with `s`, or stage the entire file with `s` from the list.
4. Press `c` to open the commit dialog, enter message, and press `Enter`.
5. Press `p` to push changes to remote.
6. Press `q` to return to shell.

### Project-Wide Rename
1. In Helix, place the cursor on the symbol to rename.
2. Press `F2` (or `Space + r`).
3. Type the new name and press `Enter`.
4. Save all modified buffers: `:wa`.

---

## 9. Helix Tutor

To run the built-in interactive tutorial:
```sh
hx --tutor
```
