# Terminal Development Setup: Ghostty + Zellij + Helix + GitUI + Fish

This guide is for developers transitioning from a VS Code-centric workflow to a terminal-first setup using Ghostty, Zellij, Helix, GitUI, and Fish. The goal is to maintain persistent multi-pane project sessions, edit using modal selections, handle Git visually, and work efficiently without GUI IDE overhead.

---

## 1. 10-Minute Quick Start

### 1. Start or Reconnect to a Project Workspace
Open Ghostty and run:
```sh
zellij attach -c my-app
```
*(Or use the alias `zj a -c my-app`). This connects to an existing session or creates a new persistent session if it does not exist.*

### 2. Set Up the 3-Pane Layout
You can launch directly with the built-in 3-pane IDE layout:
```sh
zide
```
*(Expands to `zellij --layout ide`).*

Or build the split manually from a single pane:
1. Split vertical (left and right):
   ```
   Ctrl + a  then  |
   ```
2. Move focus to the right pane:
   ```
   Ctrl + a  then  l
   ```
3. Split the right pane horizontal (top and bottom):
   ```
   Ctrl + a  then  -
   ```

### 3. Launch Tools in Their Panes
* **Left pane (70%)**: Focus with `Ctrl + a` then `h`, then launch Helix:
  ```sh
  hx .
  ```
* **Top-right pane (30%)**: Focus with `Ctrl + a` then `l`, then start your dev server or test runner:
  ```sh
  pnd     # pnpm run dev alias
  ```
* **Bottom-right pane (30%)**: Focus with `Ctrl + a` then `j`, then launch GitUI:
  ```sh
  gui
  ```

### 4. The 6 Essential Daily Shortcuts
| Action | Shortcut | Details |
| :--- | :--- | :--- |
| **Open File** | `Cmd + P` *(or `Space + f`)* | Fuzzy file finder; type 2–3 letters |
| **Global Search** | `Cmd + Shift + F` *(or `Space + /`)* | Live ripgrep search across repository |
| **Save & Format** | `Cmd + S` *(or `:w`)* | Writes file and auto-formats via `oxfmt` |
| **Switch Panes** | `Ctrl + a` then `h` / `j` / `k` / `l` | Move focus between editor, server, and git |
| **Zoom Pane** | `Ctrl + a` then `z` | Maximize focused pane to 100%; press again to restore splits |
| **Stage Changes** | In GitUI: `Enter` on file → `s` | Stages selected line or hunk into commit |

---

## 2. Architecture & Tool Roles

```
┌─────────────────────────────────────────────────────────────┐
│                 Ghostty (Terminal Emulator)                 │
│  └─ Window frame, font rendering, macOS Cmd key bridging    │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│           Zellij (Persistent Sessions, Tabs, Splits)        │
│  ├─ Tab 1: "editor" (Main Workspace)                        │
│  │   ├─ Left Pane (70%): Helix Editor                       │
│  │   ├─ Top-Right (30%): Dev Server / Watcher               │
│  │   └─ Bottom-Right (30%): GitUI                           │
│  ├─ Tab 2: "servers" (Background Daemons / Logs)            │
│  └─ Floating Pane: Scratch terminal (toggle with Ctrl+a w)  │
└─────────────────────────────────────────────────────────────┘
```

| Component | Tool in Setup | Primary Responsibility | Replaces in VSCode |
| :--- | :--- | :--- | :--- |
| **Terminal Emulator** | **Ghostty** | Hardware-accelerated window, font ligatures, macOS shortcut bridging | VSCode application window frame |
| **Workspace Multiplexer** | **Zellij** | Background sessions, tab management, persistent tiled & floating panes | Split editors, layout management, terminal panel |
| **Modal Editor** | **Helix** | Selection-first editing, syntax highlighting, LSP client (`vtsls`), formatting (`oxfmt`) | Monaco editor, LSP extensions, Prettier |
| **Git Interface** | **GitUI** | Interactive staging, line-by-line diffs, commit history, branches | Source Control panel, GitLens |
| **Interactive Shell** | **Fish** | Shell environment, autosuggestions, workflow aliases (`gui`, `zj`, `pnd`, `pn`) | Integrated terminal shell |

---

## 3. Zellij: Workspaces, Tabs, and Panes

Zellij is configured with a **simplified UI** (`simplified_ui true`) and the Tomorrow Night Blue palette. It displays regular text dividers and boxes without arrow-styled powerline fonts, while keeping on-screen key-helpers visible at the bottom.

To avoid conflicts with Helix's `Cmd + P` (`Ctrl + p` file picker) and `Cmd + S` (`Ctrl + s` save), Zellij uses **`Ctrl + a`** as its leader prefix.

### Sessions (Project Workspaces)
Sessions persist in the background across disconnects and terminal restarts.

| Action | Command / Shortcut | Description |
| :--- | :--- | :--- |
| **New or attach session** | `zellij attach -c <name>` | Connect to existing session or create it |
| **Short alias** | `zj a -c <name>` | Quick attach/create alias |
| **Detach session** | `Ctrl + a` then `d` | Leave session running in background |
| **List active sessions** | `zellij ls` *(or `zj ls`)* | Show all active sessions |
| **Kill session** | `zellij k <name>` | Terminate a session and its processes |
| **Delete dead sessions** | `zellij delete-all-sessions` | Clean up inactive session cache |

### Tabs (Virtual Workspaces)
Tabs appear along the top bar with clean brackets and numbers.

| Action | Shortcut | Description |
| :--- | :--- | :--- |
| **New tab** | `Ctrl + a` then `c` | Open a new tab |
| **Switch to tab N** | `Ctrl + a` then `1` / `2` / `3` / `4` / `5` | Switch directly to tab index |
| **Next / Prev tab** | `Ctrl + t` then `n` / `p` *(or `Right`/`Left`)* | Cycle through tabs in Tab mode |
| **Rename tab** | `Ctrl + t` then `r` | Rename the active tab |
| **Close tab** | `Ctrl + t` then `x` | Close current tab |

### Panes (Tiled & Floating Splits)
Panes divide the window into multiple active terminal regions.

| Action | Shortcut | Description |
| :--- | :--- | :--- |
| **Split vertical** | `Ctrl + a` then `\|` | Split pane left and right |
| **Split horizontal** | `Ctrl + a` then `-` | Split pane top and bottom |
| **Navigate panes** | `Ctrl + a` then `h` / `j` / `k` / `l` | Move focus left, down, up, or right |
| **Toggle zoom** | `Ctrl + a` then `z` | Maximize current pane to 100% (press again to restore) |
| **Toggle floating pane** | `Ctrl + a` then `w` | Toggle a floating scratch pane over your layout |
| **Close focused pane** | `Ctrl + a` then `x` *(or `Ctrl + d`)* | Close active pane |
| **Resize mode** | `Ctrl + a` then `r` *(or `Ctrl + n`)* | Enter resize mode; use `h/j/k/l` or `+/-` to resize |
| **Move / Reorder mode** | `Ctrl + a` then `m` *(or `Ctrl + h`)* | Enter move mode to swap pane positions |

---

## 4. GitUI: Terminal Git Interface

Launch GitUI in any pane or window:
```sh
gui
```

### Views
Switch views using **`1`**, **`2`**, **`3`**, **`4`** (or `Tab` / `Shift + Tab`):

* **`1` Status**: Working tree modifications, untracked files, and staging.
* **`2` Log**: Commit history, author and date metadata, and branch graphs.
* **`3` Files**: File tree at `HEAD` to inspect repository contents.
* **`4` Stashing**: Stash management (inspect, apply, and drop).

### Keybindings Reference

| Action | Key | Description |
| :--- | :--- | :--- |
| **Stage / Unstage File** | `s` / `u` | Stage or unstage the highlighted file |
| **Stage All** | `a` | Stage all unstaged changes across repository |
| **Discard Changes** | `D` *(Shift + d)* | Prompts to discard changes in file or selected hunk |
| **Commit** | `c` | Open commit message editor |
| **Amend Commit** | `c` then toggle amend | Add staged changes to previous commit |
| **Push** | `p` | Push committed changes to remote branch |
| **Pull** | `P` *(Shift + p)* | Pull incoming commits from remote |
| **Fetch** | `f` | Fetch remote references |
| **Branch Menu** | `b` | Switch branch, checkout, or create new branch |
| **Tag Menu** | `t` | Create or delete tags |
| **Help Menu** | `?` | Interactive keymap overview |
| **Quit** | `q` | Exit GitUI back to shell |

### Staging Line by Line
1. In the **Status** view (`1`), use `j`/`k` to select a modified file.
2. Press `Enter` to focus the diff viewer.
3. Navigate to a specific line or hunk with `j` and `k`.
4. Press `s` to stage that line or hunk (or `u` to unstage).
5. Press `Esc` to return focus to the file list.

---

## 5. Helix Editor: Key Reference Lists

Helix is a modal, selection-first editor. Actions apply to the currently selected text.

### Modes

| Mode | Status Indicator | How to Enter | How to Exit |
| :--- | :--- | :--- | :--- |
| **Normal** | `NOR` | `Esc` | Press `i`, `a`, `c`, or `v` |
| **Insert** | `INS` | `i` (before selection), `a` (after selection) | Press `Esc` |
| **Select** | `SEL` | `v` (extend selection with motions) | Press `v` or `Esc` |

### Motions & Navigation

| Key | Motion | Details |
| :--- | :--- | :--- |
| `h` / `j` / `k` / `l` | Left / Down / Up / Right | Basic character motions |
| `w` / `b` / `e` | Word start / Prev word / Word end | Word motions (selects range) |
| `W` / `B` / `E` | WORD start / Prev WORD / WORD end | Non-whitespace WORD motions |
| `x` | Select line | Press repeatedly to extend selection line by line |
| `gh` / `gl` | Line start / Line end | Move cursor to beginning or end of line |
| `gs` | First non-whitespace | Jump to first non-blank character of line |
| `gg` / `ge` | File start / File end | Jump to first or last line of file |
| `:123` then `Enter` | Go to line 123 | Direct line jump |
| `Ctrl + d` / `Ctrl + u` | Page down / Page up | Scroll half-page down or up |

### Opening Lines at Boundaries
* **Start of file**: Press `gg` then `O` *(capital O)*. Jumps to line 1, opens a blank line above it, and enters Insert mode.
* **End of file**: Press `ge` then `o` *(lowercase o)*. Jumps to the last line, opens a blank line below it, and enters Insert mode.

### Editing Actions

| Key | Action | Description |
| :--- | :--- | :--- |
| `i` / `a` | Insert before / after | Enter Insert mode at selection boundaries |
| `I` / `A` | Insert at line start / end | Jump to line boundary and enter Insert mode |
| `o` / `O` | Open line below / above | Insert new line and enter Insert mode |
| `c` | Change | Delete selection and enter Insert mode |
| `d` | Delete | Delete selection (copies text to register) |
| `y` | Yank | Copy selection to register |
| `p` / `P` | Paste after / before | Paste register contents |
| `u` / `U` | Undo / Redo | Revert or reapply changes |
| `>` / `<` | Indent / Unindent | Shift selected lines right or left |

### Text Objects & Surround (`m` Match Mode)

| Text Object | What It Selects | Example |
| :--- | :--- | :--- |
| `mi"` / `ma"` | Inside / Around double quotes | `"item"` → `item` / `"item"` |
| `mi'` / `ma'` | Inside / Around single quotes | `'item'` → `item` / `'item"` |
| `mi(` / `ma(` | Inside / Around parentheses | `(a, b)` → `a, b` / `(a, b)` |
| `mi{` / `ma{` | Inside / Around braces | `{ key }` → ` key ` / `{ key }` |
| `mi[` / `ma[` | Inside / Around brackets | `[0, 1]` → `0, 1` / `[0, 1]` |
| `mif` / `maf` | Inside / Around function | Selects entire function implementation |

* **Surround selection**: Select text, press `ms"` (surrounds with `"..."`) or `ms(` (surrounds with `(...)`).
* **Replace surround**: Inside quoted text, press `mr"'` (replaces `"` with `'`).
* **Delete surround**: Inside quoted text, press `md"` (removes surrounding quotes).

### Code Intelligence (LSP & Diagnostics)

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `F12` *(or `gd`)* | Go to Definition | Jump to symbol definition (`Ctrl + o` jumps back) |
| `Shift + F12` *(or `gr`)* | Find References | List all references in interactive fuzzy picker |
| `Space + k` *(or `K`)* | Hover Info | Show type signatures and documentation |
| `Space + a` | Code Actions | Quick fixes, imports, and linter suggestions |
| `Space + d` | File Diagnostics | List errors and warnings in current file |
| `Space + D` | Workspace Diagnostics | List errors and warnings across the project |
| `]d` / `[d` | Next / Prev Error | Jump directly to next or previous diagnostic |
| `F2` *(or `Space + r`)* | Rename Symbol | Semantic project-wide rename (commit with `:wa`) |
| `Cmd + S` *(or `:format`)* | Format File | Format file using configured formatter (`oxfmt`) |

### Buffer & File Management

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `Tab` / `Shift + Tab` | Next / Prev Buffer | Cycle through open buffers across top tab bar |
| `gn` / `gp` | Next / Prev Buffer | Vim-compatible buffer navigation |
| `Space + b` | Buffer Picker | Interactive fuzzy search of open buffers |
| `Alt + w` *(or `:bc`)* | Close Buffer | Close current buffer tab (`:bc!` force closes) |
| `:open <path>` | Open / Create File | Opens file; creates directories automatically on save |
| `:wa` | Write All | Saves all open, modified buffers to disk |

---

## 6. Daily Task Workflows

### Workflow 1: Renaming a Symbol Across the Entire Project
1. Place the cursor on the function, variable, or class name in Helix.
2. Press **`F2`** (or `Space + r`).
3. Type the new name and press `Enter`. The language server (`vtsls`) updates all references across files.
4. Type **`:wa`** and press `Enter` to commit the modified buffers to disk.

### Workflow 2: Editing Function Contents with Text Objects
1. Move the cursor inside any function body.
2. In Normal mode, press:
   ```
   m  then  i  then  f   (match inside function)
   ```
3. The entire implementation block inside the braces is selected.
4. Press **`c`** to delete the block and enter Insert mode to replace it.

### Workflow 3: Multi-Cursor Regex Search and Edit
1. Select the target section of code with `x` (or select the entire file with `%`).
2. Press **`s`** to open regex search.
3. Type the identifier or pattern to modify (e.g. `prevItem`) and press `Enter`.
4. Each match becomes an active cursor.
5. Press **`c`** to change all occurrences simultaneously.
6. Press **`,`** (comma) when done to collapse back to a single primary cursor.

### Workflow 4: Jump to Definition and Return
1. Place cursor on a function call or imported module.
2. Press **`F12`** (or `gd`) to jump directly to its definition.
3. Inspect or edit the source.
4. Press **`Ctrl + o`** to jump back to your previous location in the original file.

### Workflow 5: Splitting Multi-Line Selections
1. Select several lines of code with `x` repeated.
2. Press **`Alt + s`** to split the selection into one cursor per line.
3. Press `I` or `A` to insert text at the beginning or end of every selected line simultaneously.

---

## 7. Opening Links and URLs in Code

Terminal applications with mouse capture enabled intercept standard clicks. To open URLs:

* **From Helix (`gf`)**: Place the cursor anywhere on the URL and press `gf` (goto_file). Helix detects the `https://` protocol and opens the address in your default macOS browser.
* **From Ghostty (`Shift + Click`)**: Hold `Shift` (or `Cmd + Shift`) while clicking any link to bypass terminal mouse capture and launch the URL.

---

## 8. VSCode to Terminal Action Map

| VSCode Feature / Action | VSCode Shortcut | Terminal Equivalent | Details |
| :--- | :--- | :--- | :--- |
| **File Picker** | `Cmd + P` | `Cmd + P` / `Space + f` | Interactive fuzzy search by filename |
| **Global Text Search** | `Cmd + Shift + F` | `Cmd + Shift + F` / `Space + /` | Real-time ripgrep search across files |
| **Save & Format** | `Cmd + S` | `Cmd + S` / `:w` | Writes buffer and auto-formats (`oxfmt`) |
| **Hover Types & Docs** | Hover / `Cmd + K Cmd + I` | `Space + k` / `K` | Shows type signatures and documentation |
| **Code Actions & Fixes** | `Cmd + .` | `Space + a` | Quick fixes, imports, linter actions |
| **Go to Definition** | `F12` | `F12` / `gd` | Jump to definition (`Ctrl + o` returns) |
| **Find All References** | `Shift + F12` | `Shift + F12` / `gr` | Opens reference list in fuzzy picker |
| **Project-Wide Rename** | `F2` | `F2` / `Space + r` | Updates all references; commit with `:wa` |
| **Next / Prev Diagnostic** | `F8` / `Shift + F8` | `]d` / `[d` | Jump directly to next/previous error |
| **Toggle Line Comment** | `Cmd + /` | `Cmd + /` / `Ctrl + c` | Comments/uncomments line or selection |
| **Toggle Block Comment** | `Option + Shift + A` | `Space + C` | Wraps selection in block comments |
| **Multi-Cursor Next** | `Cmd + D` | `x` → `s` → `Enter` | Select lines, regex match, edit with `c` |
| **Git Status & Staging** | `Cmd + Shift + G` | `gui` (GitUI) | Dedicated visual staging and diff viewer |
| **Terminal Drawer / Split** | `Ctrl + ` ` / `Cmd + J` | `Ctrl + a` then `-` / `Ctrl + a` then `w` | Tiled split or floating scratch pane in Zellij |
| **Buffer Tabs** | Tab click | `Tab` / `Shift + Tab` | Cycles through open buffer tabs |
| **Close Tab** | `Cmd + W` | `Alt + w` / `:bc` | Closes active buffer tab |
| **Command Palette** | `Cmd + Shift + P` | `Cmd + Shift + P` / `Space + ?` | Searchable palette of all editor commands |

---

## 9. macOS Shortcuts & Ergonomics

### 1. Ghostty Native `Cmd` Bridges
Configured in [`configs/ghostty/.config/ghostty/config`](file:///Users/nikita/Projects/.dotfiles/configs/ghostty/.config/ghostty/config) to map standard macOS `Cmd` combinations directly to Helix commands:
* **`Cmd + S`**: Save buffer (`:w`)
* **`Cmd + P`**: File picker (`Space + f`)
* **`Cmd + /`**: Toggle line comment (`Ctrl + c`)
* **`Cmd + Shift + P`**: Command palette (`Alt + x`)
* **`Cmd + Shift + F`**: Global search (`Space + /`)

### 2. Option Key as Alt (`macos-option-as-alt = true`)
By default on macOS, terminal emulators treat the physical `⌥ Option` key as a character accent composer (typing symbols like `å`, `ç`, `ƒ`) rather than ANSI `Alt` / `Meta` escape sequences.
Ghostty is configured with:
```ini
macos-option-as-alt = true
```
This maps the physical `⌥ Option` key directly to terminal `Alt`:
* **In Zellij**: `Alt + n` (new pane), `Alt + h/j/k/l` (switch pane), `Alt + [` / `Alt + ]` (cycle tabs), `Alt + f` (floating toggle).
* **In Helix**: `Alt + s` (split selection across lines), `Alt + w` (close buffer), `Alt + x` (command palette).
* **Alternative**: Zellij also provides the `Ctrl + a` leader prefix (`Ctrl + a` then `h/j/k/l`, `|`, `-`, `z`, `w`), which requires no `Alt` key at all.
* *(Note: Ghostty requires a full app restart via `Cmd + Q` for keyboard handler updates to take effect).*

### 3. Thumb-Driven `Space` Leader Key
Most Helix commands start with `Space`, keeping actions within reach from the home row:
* `Space + f`: Open file picker
* `Space + /`: Global search
* `Space + ?`: Command palette
* `Space + b`: Switch buffers
* `Space + c`: Toggle line comment
* `Space + C`: Toggle block comment
* `Space + a`: Code actions
* `Space + k`: Type inspection

### 3. Recommended: Remap Caps Lock to Control
Shortcuts that use `Ctrl` (`Ctrl + a` prefix in Zellij, `Ctrl + o` jump back, `Ctrl + d` scroll) are significantly easier to reach when mapped to the home row:
1. Open **macOS System Settings** → **Keyboard** → **Keyboard Shortcuts…** → **Modifier Keys**.
2. Select your keyboard, and change **Caps Lock Key** to **Control**.

---

## 10. Gotchas & Terminal Nuances

### 1. Ghostty `Cmd + Shift + /` Opens Online Documentation
* On macOS, `Cmd + Shift + /` (which resolves to `Cmd + ?`) is the native OS menu shortcut for the Help menu.
* In Ghostty, pressing `Cmd + Shift + /` immediately launches your web browser and navigates to `https://ghostty.org/docs`.
* **Do not use `Cmd + Shift + /` for editor shortcuts** (such as block comments or help).
* Use **`Cmd + /`** for line comments, **`Space + C`** for block comments, and **`Cmd + Shift + P`** (or `Space + ?`) for the Command Palette.

### 2. Zellij `Ctrl + a` Leader Pass-Through
* `Ctrl + a` is the configured leader key for Zellij to prevent collisions with Helix's `Cmd + P` (`Ctrl + p`) and `Cmd + S` (`Ctrl + s`).
* To send a literal `Ctrl + a` to a shell or inner SSH session, press `Ctrl + a` twice.

### 3. Terminal Mouse Reporting vs. Text Copying
* Helix enables mouse reporting (`mouse = true`), allowing click-to-position and scroll wheel support.
* Because the editor captures clicks, clicking URLs or selecting text with the mouse does not use the macOS clipboard by default.
* **To bypass mouse capture**: Hold **`Shift`** (or `Cmd + Shift`) while dragging to select text with the native terminal, or while clicking a link to open it in your browser.

### 4. Keep GitUI in a Dedicated Split Pane
* Avoid repeatedly suspending Helix (`Ctrl + z`) or switching applications to perform Git operations.
* Keep GitUI running permanently in the bottom-right Zellij pane. Jump over with `Ctrl + a` then `j` (or `l`), stage and commit, and jump back with `Ctrl + a` then `h`.

### 5. LSP Renaming Affects In-Memory Buffers
* When running `F2` (rename symbol), the language server modifies occurrences across all files where the symbol appears.
* These files are loaded into Helix buffer memory but are not automatically written to disk.
* Always run **`:wa`** (write all) after a rename to save changes across every modified file.

---

## 11. Fish Shell Abbreviations

All workflow abbreviations expand interactively when pressing `Space` or `Enter`:

| Abbreviation | Expands To | Purpose |
| :--- | :--- | :--- |
| `zj` | `zellij` | Launch Zellij terminal multiplexer |
| `zja <name>` | `zellij attach -c <name>` | Attach to or create named session |
| `zide` | `zellij --layout ide` | Launch Zellij with 3-pane IDE layout |
| `zjl` | `zellij list-sessions` | List active sessions |
| `zjk <name>` | `zellij kill-session <name>` | Terminate a session |
| `zjd` | `zellij delete-all-sessions` | Clean up disconnected session cache |
| `helix` / `h` | `hx` | Launch Helix modal editor |
| `gui` | `gitui` | Open GitUI interface |
| `j` | `just` | Run project tasks from `justfile` |
| `pn` | `pnpm` | Package manager |
| `pnd` | `pnpm dev` | Start development server |
| `pns` | `pnpm storybook` | Start Storybook |
| `pnt` | `pnpm test:dev` | Run test suite in watch mode |
| `jq` | `jaq` | Fast Rust JSON query processor |

---

## 12. Modern CLI Utilities

Classic UNIX tools (`cat`, `ls`, `find`, `sed`) date back decades and lack project awareness. Fish bridges standard commands to modern utilities via aliases and abbreviations.

While execution speed is high, the primary benefits are sane defaults, Git awareness, and developer ergonomics:

* **`.gitignore` & project awareness**: `fd` and `rg` ignore build directories (`node_modules/`, `dist/`) and `.git/` automatically, preventing slow recursive searches.
* **Git integration**: `eza` displays file change status directly in directory lists (`ll`); `bat` shows git change markers in file gutters; `delta` highlights within-line word changes in diffs.
* **Ergonomics**: `sd` eliminates incompatible macOS/Linux `sed -i` flags and esoteric escaping; `tldr` provides 5 practical examples instead of 50-page man pages.
* **Destination jumping**: `zoxide` remembers directory frequency and recency, replacing repetitive `cd ../../` navigation with simple queries like `z <project>`.

| Modern Tool | Replaces / Alias | Command | Primary Benefit |
| :--- | :--- | :--- | :--- |
| **ripgrep** | `grep` | `rg` | Skips `.gitignore` and `node_modules/`; multiline regex |
| **fd** | `find` | `fd` | Friendly syntax; skips ignored and hidden files by default |
| **bat** | `cat` | `bat` *(or `cat`)* | Syntax highlighting, line numbers, git diff gutter markers |
| **eza** | `ls` | `eza` *(or `ls`, `ll`)* | Git modification status column, tree view (`lt`), file icons |
| **delta** | `diff` | `delta` | Word-level diff highlighting, side-by-side split view |
| **zoxide** | `cd` | `z`, `zi` | Fuzzy directory jumping (`z <query>`, `zi` for interactive picker) |
| **sd** | `sed` | `sd` | Standard PCRE regex; consistent syntax across macOS and Linux |
| **jaq** | `jq` | `jaq` *(or `jq`)* | Precise number handling and clearer error diagnostics |
| **tealdeer** | `man` | `tldr` | Practical, task-oriented examples for fast copy-pasting |

---

## 13. Built-in Tutor

Helix includes an interactive tutorial to practice motions directly in the terminal:
```sh
hx --tutor
```
