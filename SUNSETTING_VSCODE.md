# Terminal Development Setup: Kitty + Zellij + Helix + GitUI + Fish

A guide to using Kitty, Zellij, Helix, GitUI, and Fish as a daily development environment on macOS. Covers workspace sessions, editing, Git staging, and keyboard shortcuts.

---

## 1. 10-Minute Quick Start

### 1. Start or Reconnect to a Project Workspace
Open Kitty and run:
```sh
ws my-app
```
*(Or simply `ws` to auto-resume your most recent workspace).*

### 2. Default 2-Tab Workspace Layout
Starting a session with `ws` opens the default 2-tab layout with tools already running:

* **Tab 1 (`Code`)**:
  * **Top pane (85%)**: Helix (`hx`) running in the current directory.
  * **Bottom pane (15%)**: Terminal shell ready for dev servers (`pnd`), tests (`pnt`), or commands.
* **Tab 2 (`Git`)**:
  * **Left pane (50%)**: GitUI (`gitui`) running in the current directory.
  * **Right pane (50%)**: Terminal shell for git CLI commands or secondary tasks.

Switch tabs with `Ctrl + a` → `t` → `Tab` (or `1` / `2`). Switch panes with `Ctrl + a` → `p` → `h`/`j`/`k`/`l`.

### 4. Essential Daily Shortcuts

#### Helix (Editor Actions: `Cmd` ⌘)
| Action | Shortcut | Details |
| :--- | :--- | :--- |
| **Open File** | `Cmd + P` *(or `Space + f`)* | Fuzzy file finder; type 2–3 letters |
| **Global Search** | `Cmd + Shift + F` *(or `Space + /`)* | Search across repository |
| **Close File Tab** | `Cmd + W` *(or `:bc`)* | Closes active buffer tab |
| **Switch Buffer Tabs** | `Cmd + [` / `Cmd + ]` | Move to previous / next file tab in Helix |
| **Jump Points Back/Fwd**| `Cmd + Shift + [` / `]` *(or `Ctrl + o/i`)*| Jump backward / forward across definitions (jumplist) |
| **Multi-Cursor Next Match**| `Cmd + D` | Incrementally select next word occurrence |
| **Quick Fix / Imports** | `Cmd + .` *(or `Space + a`)* | Trigger code actions, auto-imports, linter fixes |
| **Hover Docs** | `Cmd + I` *(or `K`)* | View documentation / type signature under cursor |
| **Next / Prev Error** | `Cmd + E` / `Cmd + Shift + E` | Jump directly to next / previous diagnostic |
| **Toggle Comment** | `Cmd + /` *(or `Ctrl + c`)* | Comments/uncomments line or selection |
| **Toggle Block Comment**| `Cmd + Shift + /` *(or `Space + C`)*| Wraps selection in block comments |
| **Split Editor Right** | `Cmd + \` *(or `Ctrl + w` → `v`)* | Side-by-side vertical split |
| **Save & Format** | `Cmd + S` *(or `Ctrl + s` / `:w`)* | Saves file and formats with `dprint` / `oxfmt` |
| **Undo / Redo** | `Cmd + Z` / `Cmd + Shift + Z` | Undo and redo in Normal mode |

#### Zellij (Workspace Actions: `Option` ⌥)
| Action | Shortcut | Details |
| :--- | :--- | :--- |
| **Switch Workspace Tabs**| `Option + [` / `Option + ]` | Cycle Zellij workspace tabs (Code ↔ Git) |
| **Jump to Tab 1–9** | `Option + 1` .. `Option + 9` | Jump directly to Zellij Tab index |
| **New Workspace Tab** | `Option + T` | Open a new Zellij tab |
| **Close Workspace Tab** | `Option + W` | Close current Zellij tab |
| **Switch Panes** | `Option + Down` / `Option + Up` *(or `Option + j/k`)* | Instantly jump focus between Helix and Terminal |
| **Zoom Pane** | `Option + Z` | Maximize focused pane; press again to restore |
| **Close Focused Pane** | `Option + X` | Close active pane |
| **Stage Changes** | In GitUI: `Enter` on file | Stages highlighted file (`→` into diff to stage hunks/lines) |

---

## 2. Tools Overview

```
┌─────────────────────────────────────────────────────────────┐
│                  Kitty (Terminal Emulator)                  │
│  └─ Window, font rendering, macOS Cmd shortcuts             │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│           Zellij (Sessions, Tabs, Splits)                   │
│  ├─ Tab 1: Code (Active)                                    │
│  │   ├─ Top Pane (85%): Helix Editor (running hx)           │
│  │   └─ Bottom Pane (15%): Terminal shell                   │
│  ├─ Tab 2: Git                                              │
│  │   ├─ Left Pane (50%): GitUI (running gitui)              │
│  │   └─ Right Pane (50%): Terminal shell                    │
│  └─ Floating Pane: Scratch terminal (Ctrl+a -> p -> w)      │
└─────────────────────────────────────────────────────────────┘
```

| Component | Tool in Setup | Role |
| :--- | :--- | :--- |
| **Terminal Emulator** | **Kitty** | Hardware-accelerated window, font ligatures, macOS shortcut bridging |
| **Workspace Multiplexer** | **Zellij** | Background sessions, tab management, tiled and floating split panes |
| **Modal Editor** | **Helix** | Text editing, syntax highlighting, LSP client (`vtsls`), formatting (`dprint`) |
| **Git Interface** | **GitUI** | Terminal-based staging, line-by-line diffs, commit history, branches |
| **Interactive Shell** | **Fish** | Shell environment, autosuggestions, workflow shortcuts (`ws`, `ed`, `gg`, `pnd`) |

### Why These Tools

* **Kitty**: Fast GPU rendering on macOS and straightforward key mapping for `Cmd` shortcuts (`Cmd + S`, `Cmd + P`, etc.).
* **Zellij**: Keeps dev servers and editor sessions running in the background across terminal disconnects, with layouts defined in plain text files.
* **Helix**: Includes LSP support, syntax highlighting, and code formatting out of the box without requiring extra plugins.
* **GitUI**: Fast keyboard-driven interface for inspecting diffs and staging hunks without leaving the terminal.
* **Fish**: Helpful autosuggestions and abbreviations that expand in-place.
* **CLI Utilities (`rg`, `fd`, `bat`, `eza`, `delta`, `zoxide`)**: Fast command-line tools that respect `.gitignore` and show Git status by default.

---

## 3. Zellij: Workspaces, Tabs, and Panes

Zellij uses the Tomorrow Night Blue palette with a default 2-tab layout: Tab 1 (`Code`) features the Helix editor on top (85%) and a terminal shell below (15%); Tab 2 (`Git`) provides a 50/50 vertical split with GitUI on the left and a terminal shell on the right.

### Pane Frames & Status Bar
* **Active vs. Inactive Panes**: The focused pane has a warm gold border (`#ffeead`), while inactive panes use dark navy (`#183d6e`).
* **Key Guide**: Pressing `Ctrl + a` shows available categories at the bottom (`p:pane`, `t:tab`, `r:resize`, `m:move`, `s:scroll`, `d:detach`, `q:quit`). Entering a category shows its specific keys.
* **Key Routing**: Pane actions route through `p` (e.g. `Ctrl + a` → `p`), and tab actions route through `t`.

### Sessions (Project Workspaces)
Sessions persist in the background across disconnects and terminal restarts.

| Action | Command / Shortcut | Description |
| :--- | :--- | :--- |
| **Resume latest workspace** | `ws` | Auto-attach to most recent session (or start fresh default layout) |
| **Attach or create named workspace** | `ws <name>` | Connect to existing workspace or create it |
| **List active workspaces** | `ws ls` | Show all active workspaces |
| **Kill workspace** | `ws k <name>` | Terminate a workspace and its processes |
| **Delete dead workspaces** | `ws da` | Clean up inactive session cache |
| **Detach workspace** | `Ctrl + a` → `d` | Leave workspace running in background |
| **Quit Zellij** | `Ctrl + q` *(or `Ctrl + a` → `q`)* | Exit session and terminate all running processes |

### Tabs (Virtual Workspaces)
Tabs appear along the bottom status bar with clean numbering. Tabs are managed directly with `Option` (⌥) shortcuts, or routed through the `Ctrl + a` → `t` menu:

| Action | Fast Shortcut | Menu Fallback | Description |
| :--- | :--- | :--- | :--- |
| **New tab** | `Option + T` | `Ctrl + a` → `t` → `c` | Open a new tab |
| **Switch to tab N** | `Option + 1` .. `Option + 9` | `Ctrl + a` → `t` → `1` .. `9` | Switch directly to tab index |
| **Next / Prev tab** | `Option + ]` / `Option + [` | `Ctrl + a` → `t` → `Tab` / `p` | Cycle through tabs |
| **Move tab left / right** | — | `Ctrl + a` → `t` → `h` / `l` | Shift tab position left or right (`Enter`/`Esc` done) |
| **Rename tab** | — | `Ctrl + a` → `t` → `,` | Rename the active tab (`Enter` to save, `Esc` to cancel) |
| **Close tab** | `Option + W` | `Ctrl + a` → `t` → `x` | Close the current tab |

### Panes & Navigation (Tiled & Floating Splits)
Panes divide the window into active terminal regions. Most frequent actions have fast single-keystroke `Option` (⌥) shortcuts, while full pane control is available via `Ctrl + a` → `p`:

| Action | Fast Shortcut | Menu Fallback | Description |
| :--- | :--- | :--- | :--- |
| **Switch Editor / Terminal** | `Option + Down` / `Option + Up` | `Ctrl + a` → `p` → `j` / `k` | Jump focus between Helix and Terminal |
| **Navigate panes** | `Option + H` / `J` / `K` / `L` *(or arrows)* | `Ctrl + a` → `p` → `h` / `j` / `k` / `l` | Move focus in direction |
| **Toggle zoom** | `Option + Z` | `Ctrl + a` → `p` → `z` | Maximize current pane to 100% (press again to restore) |
| **Toggle floating pane** | `Option + \`` *(or `Option + P`)* | `Ctrl + a` → `p` → `w` | Toggle a floating scratch pane over layout |
| **Close focused pane** | `Option + X` | `Ctrl + a` → `p` → `x` | Close active pane |
| **Split vertical** | `Option + \|` | `Ctrl + a` → `p` → `\|` | Split pane left and right |
| **Split horizontal** | `Option + -` | `Ctrl + a` → `p` → `-` | Split pane top and bottom |
| **New unconstrained pane** | `Option + n` | `Ctrl + a` → `p` → `n` | Create a new pane in default orientation |
| **Cycle focus** | — | `Ctrl + a` → `p` → `o` | Move focus to the next pane |
| **Rename pane** | — | `Ctrl + a` → `p` → `,` | Rename focused pane (`Enter` to save, `Esc` to cancel) |
| **Break to new tab** | — | `Ctrl + a` → `p` → `b` | Move focused pane out into a new tab |
| **Move pane to adjacent tab**| — | `Ctrl + a` → `p` → `[` / `]` | Send focused pane into adjacent tab |

### Modes & Utilities
Dedicated modal states provide interactive manipulation without key collisions:

| Action | Shortcut | Description |
| :--- | :--- | :--- |
| **Resize mode** | `Ctrl + a` → `r` | Enter resize mode (`h/j/k/l` grow, `H/J/K/L` shrink, `+/-`, `Esc` done) |
| **Move / Swap mode** | `Ctrl + a` → `m` | Enter swap mode (`h/j/k/l` swap, `n/p` cycle, `Esc` done) |
| **Scroll / Copy mode** | `Ctrl + a` → `s` | Enter scrollback history (`j/k`, `u/d` half page, `/` search, `e` edit, `q/Esc` exit) |
| **Help modal** | `Ctrl + a` → `?` | Open interactive Zellij keybinding & configuration browser |
| **Send literal Ctrl+A** | `Ctrl + a` → `Ctrl + a` | Pass `Ctrl + a` to shell/editor (e.g. jump to line start) |

---

## 4. GitUI: Terminal Git Interface

Launch GitUI in any pane or window:
```sh
gg
```

### Views
Switch views using **`1`**, **`2`**, **`3`**, **`4`**, **`5`** (or `Tab` / `Shift + Tab`):

* **`1` Status**: Working tree modifications, untracked files, and staging.
* **`2` Log**: Commit history, author and date metadata, and branch graphs.
* **`3` Files**: File tree at `HEAD` to inspect repository contents.
* **`4` Stashing**: Stash management (save, apply, and drop).
* **`5` Stashes**: Inspect saved stashes.

### Keybindings Reference

| Action | Key | Description |
| :--- | :--- | :--- |
| **Navigate** | `↑` / `↓` / `←` / `→` | Move between items and panels |
| **Switch Work Area** | `w` | Jump focus between Unstaged and Staged changes |
| **Stage / Unstage File** | `Enter` | Stage or unstage the highlighted file |
| **Stage All** | `a` | Stage all unstaged changes across repository |
| **Discard Changes** | `D` *(Shift + d)* | Prompts to discard changes in file or hunk |
| **Ignore File** | `i` | Add selected file to `.gitignore` |
| **Focus Diff Viewer** | `→` *(Right arrow)* | Move focus into the diff pane for selected file |
| **Return to File List** | `←` *(Left arrow)* / `Esc` | Return focus from diff viewer to file list |
| **Stage / Unstage Hunk** | `Enter` *(in diff)* | Add or remove the selected hunk to/from staging |
| **Stage / Unstage Line** | `s` *(in diff)* | Stage or unstage the selected line |
| **Reset Line / Hunk** | `d` / `D` *(in diff)* | Reset selected line (`d`) or hunk (`Shift + d`) |
| **Next / Prev Hunk** | `n` / `p` *(in diff)* | Jump to next or previous change hunk |
| **Commit** | `c` | Open commit message editor (when changes staged) |
| **Undo Commit** | `U` *(Shift + u)* | Undo the most recent commit |
| **Push** | `p` | Push committed changes to remote |
| **Pull** | `f` | Pull changes from remote |
| **Fetch** | `F` *(Shift + f)* | Fetch remote references |
| **Branch Menu** | `b` | Switch, create, or checkout branches |
| **Tag Menu** | `t` | Create, annotate, or delete tags |
| **Submodules** | `S` *(Shift + s)* | Open submodules menu |
| **Blame** | `B` *(Shift + b)* | View git blame for selected file |
| **File History** | `H` *(Shift + h)* | Inspect log history for selected file |
| **Edit File** | `e` | Open highlighted file in `$EDITOR` |
| **Help Menu** | `h` | Interactive all-commands cheat sheet |
| **Quit** | `q` *(or `Ctrl + c`)* | Exit GitUI back to shell |

### Staging Line by Line & Hunks
1. In the **Status** view (`1`), use `↑`/`↓` to highlight a modified file.
2. Press `→` (Right arrow) to move focus into the diff viewer.
3. Jump between hunks with `n` and `p`, or move line-by-line with `↑` and `↓`.
4. Press `Enter` to stage the selected hunk, or press `s` to stage individual lines.
5. Press `←` (Left arrow) or `Esc` to return focus to the file list.

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

### LSP & Diagnostics

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `gd` | Go to Definition | Jump to symbol definition (`Ctrl + o` jumps back) |
| `gr` | Find References | List all references in interactive fuzzy picker |
| `Space + k` *(or `K`)* | Hover Info | Show type signatures and documentation |
| `Space + i` | Toggle Inlay Hints | Toggle inline type/parameter annotations on demand |
| `Space + a` | Code Actions | Quick fixes, imports, and linter suggestions |
| `Space + d` | File Diagnostics | List errors and warnings in current file |
| `Space + D` | Workspace Diagnostics | List errors and warnings across the project |
| `]d` / `[d` | Next / Prev Error | Jump directly to next or previous diagnostic |
| `Space + r` | Rename Symbol | Project-wide rename (commit with `:wa`) |
| `Cmd + S` / `Ctrl + s` *(or `:w`)* | Save & Format | Save and format file with configured formatter (`dprint`) |

### Buffer & File Management

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `Cmd + P` *(or `Space + f`)* | File Picker | Fuzzy search files across repository |
| `Cmd + Shift + F` *(or `Space + /`)* | Global Search | Search text across repository |
| `Cmd + F` *(or `/`)* | Find in Buffer | Search within the current file |
| `Cmd + W` *(or `:bc`)* | Close Buffer | Close current buffer tab (`:bc!` forces close without save) |
| `Cmd + [` / `Cmd + ]` | Switch Buffer Tabs | Move to previous / next file tab in Helix |
| `Cmd + Shift + [` / `]` *(or `Ctrl + o/i`)*| Jump Points Back / Fwd | Jump backward / forward across definitions (jumplist) |
| `Cmd + B` *(or `Space + b`)* | Buffer Picker | Interactive fuzzy search of open buffers |
| `gn` / `gp` | Next / Prev Buffer | Vim-style cycle to next or previous open buffer |
| `Cmd + R` *(or `:rl`)* | Reload File | Reload current file from disk (syncs external changes) |
| `:reload-all` *(or `:rla`)* | Reload All Files | Reload all open buffers from disk |
| `:wa` | Write All | Saves all open, modified buffers to disk |

---

## 6. Daily Task Workflows

### Workflow 1: Renaming a Symbol Across the Entire Project
1. Place the cursor on the function, variable, or class name in Helix.
2. Press **`Space + r`**.
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

### Workflow 3: Multiple Cursors & Column Editing (Mac Option = Alt)
* **Column cursors below / above**:
  * Press **`C`** *(Shift + c)* to duplicate the cursor to the line below.
  * Press **`Option + C`** *(⌥ + Shift + c)* to duplicate the cursor to the line above.
* **Split lines into individual cursors**:
  * Select a block of lines with **`x`** (or `5x`).
  * Press **`Option + s`** *(⌥ + s)* to split the selection into one cursor per line.
  * Press **`I`** to insert at the beginning of each line, or **`A`** at the end.
* **Find and replace all occurrences in a file**:
  1. Cursor on word → press **`*`** (registers target word).
  2. Select whole file with **`%`** (or select lines with `x`).
  3. Press **`s`** then **`Enter`** (creates an active cursor on every match).
  4. Press **`c`** to change all instances simultaneously.
* **Exit multi-cursor mode**:
  * Press **,** *(comma)* to drop all extra cursors and keep only the primary cursor.

### Workflow 4: Jump to Definition and Return
1. Place cursor on a function call or imported module.
2. Press **`gd`** to jump directly to its definition.
3. Inspect or edit the source.
4. Press **`Ctrl + o`** to jump back to your previous location in the original file.

### Workflow 5: Project-Wide Find & Replace Across Multiple Files
When replacing a string across dozens of files in the project:
1. In the terminal (or bottom Zellij pane), use **`rg`** to inspect matches:
   ```sh
   rg "oldText"
   ```
2. Run **`sd`** (fast regex replacer) across all matching files:
   ```sh
   sd 'oldText' 'newText' (rg -l 'oldText')
   ```
3. If files are already open in Helix, run **`:rla`** (`:reload-all`) to sync changes from disk.

### Workflow 6: Resolving Git Merge Conflicts
1. In Tab 2 (`Git`) with GitUI, conflicting files are highlighted with conflict markers.
2. Switch to Tab 1 (`Code`) in Helix and open the conflicting file.
3. Search for conflict markers:
   ```
   /<<<<<<<  then  Enter
   ```
4. Jump between markers with **`n`** (next) and **`N`** (prev). Resolve the conflict by deleting unwanted lines with **`x`** → **`d`**.
5. Save the resolved file with **`Cmd + S`** (`:w`).
6. Switch back to Tab 2 (`Git`), highlight the resolved file, and press **`Enter`** (or `s`) to mark as resolved/staged.

### Workflow 7: Line-by-Line & Hunk-Level Git Staging in GitUI
1. In Tab 2 (`Git`), navigate files with `↑` / `↓`.
2. Press **`→`** (right arrow) to focus the diff viewer.
3. **Stage a specific hunk**: Press **`n`** / **`p`** to cycle hunks; press **`Enter`** or **`s`** to stage only the highlighted hunk.
4. **Stage specific lines**: Press **`v`** or **`l`** to switch to line-staging mode, select lines, and press **`s`** to stage just those lines.
5. Press **`←`** (left arrow) or **`Esc`** to return to the file list.

### Workflow 8: Git Stashing & Branch Switching in GitUI
* **Stashes**:
  1. In GitUI, press **`z`** to open the Stash manager.
  2. Press **`s`** to create a new stash (type message, hit `Enter`).
  3. To pop/apply: select stash from list and press **`a`** (apply) or **`d`** (drop).
* **Branches**:
  1. Press **`b`** to open the Branch manager.
  2. Select any local or remote branch and press **`Enter`** to checkout.
  3. Press **`c`** to branch from current HEAD.

### Workflow 9: Side-by-Side Splits (Helix vs. Zellij)
* **Inside Helix (`Ctrl + w` splits)**:
  * Best for comparing two files or viewing types while coding in the same project.
  * **`Ctrl + w` → `v`**: Open vertical split.
  * **`Ctrl + w` → `s`**: Open horizontal split.
  * **`Ctrl + w` → `h`/`j`/`k`/`l`**: Switch focus between splits.
  * **`Ctrl + w` → `q`**: Close active split (buffer stays loaded).
* **In Zellij (`Ctrl + a` panes)**:
  * Best for separate terminal tasks, test watchers, or viewing a second repository.
  * **`Ctrl + a` → `p` → `|`**: Vertical split pane.
  * **`Ctrl + a` → `p` → `z`**: Zoom/maximize active pane (press again to unzoom).

### Workflow 10: Smart Automatic Code Formatting (`hx-fmt`)
Formatting on save is automated via the lightweight `hx-fmt` wrapper:
* If a repository has an `oxfmt` config (`.oxfmtrc*`, `oxfmt.config*`), it automatically formats via **`oxfmt`** using that repo's rules.
* Otherwise, it defaults to **`dprint`** via your global `~/.config/dprint/dprint.jsonc`.
* Zero manual toggling required.

### Workflow 11: Opening URLs, GitHub PRs, and File Paths
* **From Helix (`gf`)**: Place the cursor on any URL (`https://...`) or relative file path and press **`gf`** (*Go to File*). URLs open immediately in your browser; file paths open directly in a new buffer.
* **From Kitty**: Hold **`Cmd`** (or **`Shift`**) while clicking any link or PR URL in terminal output to open in your browser.

### Workflow 12: Debugging in the Browser
This environment is optimized for web/frontend development:
1. Run your dev server in the bottom 15% terminal pane (`pnd`).
2. Open the app in your browser and use **Chrome / Safari DevTools** for breakpoints, DOM inspection, and console debugging.
3. Edit code in Helix on top; changes reload instantly via Vite/Next/Astro HMR.

---

## 7. VSCode to Terminal Action Map

| VSCode Feature / Action | VSCode Shortcut | Terminal Equivalent | Details |
| :--- | :--- | :--- | :--- |
| **File Picker** | `Cmd + P` | `Cmd + P` *(or `Space + f`)* | Fuzzy search by filename |
| **Global Text Search** | `Cmd + Shift + F` | `Cmd + Shift + F` *(or `Space + /`)* | Search across files |
| **Find in File** | `Cmd + F` | `Cmd + F` *(or `/`)* | Search in current buffer |
| **Close Tab / Buffer** | `Cmd + W` | `Cmd + W` *(or `:bc`)* | Closes active buffer tab |
| **Save & Format** | `Cmd + S` | `Cmd + S` / `:w` | Writes buffer and auto-formats (`hx-fmt`) |
| **Undo / Redo** | `Cmd + Z` / `Cmd + Shift + Z` | `Cmd + Z` / `Cmd + Shift + Z` | Direct undo and redo in Normal mode |
| **Switch Buffer Tabs** | `Cmd + [` / `Cmd + ]` | `Cmd + [` / `Cmd + ]` | Move to previous / next file tab in Helix |
| **Jump Points Back/Fwd**| `Cmd + Shift + [` / `]` | `Cmd + Shift + [` / `]` *(or `Ctrl + o/i`)*| Jump backward / forward across definitions (jumplist) |
| **Toggle Line Comment** | `Cmd + /` | `Cmd + /` *(or `Ctrl + c`)* | Comments/uncomments line or selection |
| **Toggle Block Comment** | `Cmd + Shift + /` | `Cmd + Shift + /` *(or `Space + C`)*| Wraps selection in block comments |
| **Hover Types & Docs** | `Cmd + I` | `Cmd + I` *(or `Space + k` / `K`)* | Shows type signatures and documentation |
| **Toggle Inlay Hints** | Settings toggle | `Space + i` | Toggles inline type/parameter annotations |
| **Code Actions & Fixes** | `Cmd + .` | `Cmd + .` *(or `Space + a`)* | Quick fixes, imports, linter actions |
| **Go to Definition** | `F12` / `Cmd + Click` | `gd` | Jump to definition (`Cmd + Shift + [` returns) |
| **Find All References** | `Shift + F12` | `gr` | Opens reference list in fuzzy picker |
| **Project-Wide Rename** | `F2` | `Space + r` | Updates all references; commit with `:wa` |
| **Next / Prev Diagnostic** | `Cmd + E` / `Cmd + Shift + E` | `Cmd + E` / `Cmd + Shift + E` *(or `]d` / `[d`)* | Jump directly to next/previous error |
| **Multi-Cursor Match Next**| `Cmd + D` | `Cmd + D` | Incrementally select next word occurrence |
| **Clear Multi-Cursors** | `Esc` | `,` *(comma)* | Collapses back to single primary cursor |
| **Split Editor Right** | `Cmd + \` | `Cmd + \` *(or `Ctrl + w` → `v`)* | Side-by-side vertical split |
| **Multi-Cursor Add Below** | `Cmd + Option + ↓` | `C` | Adds cursor to line below |
| **Multi-Cursor Add Above** | `Cmd + Option + ↑` | `Option + C` *(⌥ + Shift + c)* | Adds cursor to line above |
| **Multi-Cursor Split Lines**| `Option + Shift + I` | `Option + s` *(⌥ + s)* | Splits selected lines into cursors |
| **Git Status & Staging** | `Cmd + Shift + G` | `gg` (or Zellij Tab 2) | Interactive staging and diffs |
| **Switch Editor / Terminal**| `Cmd + J` / `Cmd + ` ` | `Option + Down` / `Option + Up` | Jump between Helix editor and Terminal |
| **Zoom Active Pane** | `Cmd + Shift + Enter` | `Option + Z` | Maximize focused pane |
| **Workspace Tabs** | `Cmd + 1` .. `Cmd + 9` | `Option + 1` .. `Option + 9` | Direct jump to Tab (1: Code, 2: Git) |
| **Cycle Workspace Tabs** | `Option + [` / `Option + ]` | `Option + [` / `Option + ]` | Cycle between Zellij workspace tabs |
| **New Workspace Tab** | `Cmd + T` | `Option + T` | Open new workspace tab |
| **Close Workspace Tab** | `Cmd + W` (in shell) | `Option + W` | Close active Zellij tab |
| **Buffer Tabs** | Tab click | `Cmd + B` / `gn` / `gp` | Switch or search open buffer tabs |
| **Reload from Disk** | Auto / Manual reload | `Cmd + R` *(or `:rl` / `:rla`)* | Reload active / all buffers from disk |

---

## 8. macOS Shortcuts & Ergonomics

### 1. Helix Editor (`Cmd` ⌘) Bridged via Kitty
Kitty maps standard macOS `Cmd` shortcuts directly to Helix control codes, dedicated exclusively to file and editing actions:
* `Cmd + P`: File picker (sends `\x10` → Helix `file_picker`).
* `Cmd + F`: Find in buffer (sends `\x06` → Helix `search`).
* `Cmd + Shift + F`: Global project search (sends `\x07` → Helix `global_search`).
* `Cmd + W`: Close buffer tab (sends `\x17` → Helix `:buffer-close`).
* `Cmd + [` / `Cmd + ]`: Move to previous / next buffer tab in Helix.
* `Cmd + Shift + [` / `Cmd + Shift + ]`: Jump backward / forward across definitions (jumplist).
* `Cmd + D`: Multi-cursor incremental selection of matching word.
* `Cmd + .`: Quick fix / Code actions and imports.
* `Cmd + I`: Hover documentation modal.
* `Cmd + E` / `Cmd + Shift + E`: Jump to next / previous error or diagnostic.
* `Cmd + Shift + /`: Toggle block comment.
* `Cmd + \`: Split editor vertically.
* `Cmd + S`: Save & format (sends `\x13` → Helix `:write`).
* `Cmd + Z` / `Cmd + Shift + Z`: Undo / Redo in Normal mode.
* `Cmd + /`: Toggle line/selection comment in Helix.

### 2. Zellij Workspace (`Option` ⌥)
Because Kitty is configured with `macos_option_as_alt yes`, pressing `Option` natively controls the Zellij multiplexer without touching editor buffers:
* `Option + [` / `Option + ]`: Cycle workspace tabs (Code ↔ Git).
* `Option + 1` .. `Option + 9`: Direct jump to workspace tab index.
* `Option + T`: New workspace tab.
* `Option + W`: Close active workspace tab.
* `Option + Down` / `Option + Up`: Jump focus between Helix editor and Terminal panes.
* `Option + H / J / K / L` *(or Arrows)*: Navigate panes in all directions.
* `Option + Z`: Toggle pane zoom (maximize / restore).
* `Option + X`: Close active pane.
* `Option + \`` *(or `Option + P`)*: Toggle floating scratch pane.
* `Cmd + Down` / `Cmd + Up`: Instant jump between Helix and Terminal panes.
* `Cmd + Shift + Enter`: Toggle pane zoom (fullscreen).

### 2. Option Key as Alt (`macos_option_as_alt yes`)
By default on macOS, the `⌥ Option` key types special characters (such as `å` or `ç`). Kitty is configured with `macos_option_as_alt yes`, mapping `Option` directly as `Alt`.
* `Option + s` *(⌥ + s)*: Split lines into multiple cursors.
* `Option + C` *(⌥ + Shift + c)*: Add cursor on line above.
* `Option + ,` *(⌥ + ,)*: Drop active cursor from multi-cursor group.
* *Terminal fallback*: Pressing and releasing **`Esc`** then pressing any key sends the exact same signal as `Option + key`.

### 3. Helix Space Menu
The vast majority of Helix operations begin cleanly with `Space`:
* `Space + f`: File picker
* `Space + /`: Global project search
* `Space + b`: Open buffers picker
* `Space + i`: Toggle inlay type hints
* `Space + r`: Rename symbol project-wide
* `Space + a`: Code actions & imports
* `Space + k`: Hover type signature
* `Space + c` / `Space + C`: Line / block comments

### 4. Recommended: Remap Caps Lock to Control
Shortcuts that use `Ctrl` (`Ctrl + a` prefix in Zellij, `Ctrl + o` jump back, `Ctrl + d` scroll) are easier to reach when mapped to Caps Lock:
1. Open **macOS System Settings** → **Keyboard** → **Keyboard Shortcuts…** → **Modifier Keys**.
2. Select your keyboard, and change **Caps Lock Key** to **Control**.

---

## 10. Gotchas & Tips

### 1. Zellij Ctrl+A Pass-Through
* `Ctrl + a` is the leader key for Zellij.
* To send a literal `Ctrl + a` to a shell or inner SSH session, press `Ctrl + a` twice.

### 2. Mouse Selection vs. Copying
* Helix has mouse support enabled for clicking and scrolling.
* To select text with the native terminal or click links directly, hold **`Shift`** (or `Cmd + Shift`) while selecting or clicking.

### 3. Use GitUI in Tab 2
* Tab 2 (`Git`) runs GitUI automatically. Switch to it with `Ctrl + a` → `t` → `Tab` (or `2`), stage and commit changes, and switch back to code with `Ctrl + a` → `t` → `1`. GitUI can also be run in any terminal pane using `gg`.

### 4. LSP Renaming Affects In-Memory Buffers
* When running `F2` (rename symbol), Helix modifies the symbol across open buffers.
* Run **`:wa`** (write all) afterward to save all modified files to disk.

---

## 11. Workflow Shortcuts

### 2-Letter Tools
Quiet, tool-agnostic commands that execute directly without rewriting the prompt:

| Command | Action | Details |
| :--- | :--- | :--- |
| `ws` | Workspace Manager | Auto-resumes most recent session; or starts fresh 2-tab layout |
| `ws <name>` | Named Workspace | Attaches to or creates named workspace session |
| `ws ls` | List Workspaces | Lists active sessions |
| `ws k <name>` | Kill Workspace | Terminates a workspace session |
| `ws da` | Delete Dead | Cleans up disconnected sessions |
| `ed <path>` | Editor | Launches `$EDITOR` (Helix) |
| `gg` | Git Interface | Opens GitUI |
| `md <file>` | Markdown View | Renders Markdown in terminal with `mdcat` |
| `jq` | JSON Processor | Runs `jaq` |

### Interactive Package Manager Abbreviations
Expand in-place upon pressing `Space` or `Enter` so custom flags and arguments can be viewed and edited:

| Abbreviation | Expands To | Purpose |
| :--- | :--- | :--- |
| `pn` | `pnpm` | Package manager |
| `pnd` | `pnpm dev` | Start development server |
| `pns` | `pnpm storybook` | Start Storybook |
| `pnt` | `pnpm test:dev` | Run test suite in watch mode |

---

## 12. Modern CLI Utilities

Standard commands are aliased to modern alternatives with helpful defaults, Git awareness, and simpler syntax:

* **Ignoring build folders**: `fd` and `rg` skip `node_modules/`, `dist/`, and `.git/` automatically.
* **Git status**: `eza` shows file changes in directory listings (`ll`), `bat` shows diff markers in file margins, and `delta` highlights line diffs.
* **Simpler syntax**: `sd` uses standard regex across platforms (replacing `sed -i` quirks), and `tldr` shows concise examples for common commands.
* **Directory jumping**: `zoxide` tracks frequently used directories, allowing jumps like `z <project>` instead of typing full paths.

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
| **mdcat** | markdown cat | `mdcat` *(or `md`)* | Renders Markdown with inline images (Kitty protocol), Mermaid diagrams, and live watch (`-w`) |

---

## 13. Built-in Tutor

Helix includes an interactive tutorial to practice motions directly in the terminal:
```sh
hx --tutor
```
