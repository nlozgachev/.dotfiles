# Helix Guide for VSCode Users

A practical reference for Helix concepts, daily navigation, text manipulation, and project workflows configured in this dotfiles setup.

---

## 1. The Editing Model: Selection First

Vim uses a verb-first model (`d w` deletes a word). You do not see what the range covers until after the text is deleted.

Helix uses a selection-first model:
1. `w` moves to the next word and highlights it.
2. You see the highlighted range.
3. `d` deletes the selection, or `c` deletes it and switches to Insert mode.

In Helix, the cursor is always a selection of at least one character. Motions expand or move this selection.

---

## 2. Modes

Helix has three primary modes shown in the bottom-left status bar:

| Mode | Status | Purpose | How to enter | How to exit |
| :--- | :--- | :--- | :--- | :--- |
| **Normal** | `NOR` | Navigation, selecting text, issuing commands | Press `Esc` | Press `i`, `a`, `c`, or `v` |
| **Insert** | `INS` | Typing code normally | Press `i` (before selection) or `a` (after selection) | Press `Esc` |
| **Select** | `SEL` | Extending selections (similar to holding `Shift` in VSCode) | Press `v` | Press `v` or `Esc` |

---

## 3. Daily Shortcut Reference

Shortcuts configured in this dotfiles repository:

### File and Project Navigation
| Action | Shortcut |
| :--- | :--- |
| File picker | `Ctrl + p` (or `Space + f`) |
| Project search (live grep) | `Space + /` |
| Open buffers list | `Space + b` |
| Save and auto-format | `Ctrl + s` (works in Normal and Insert mode) |
| Close current buffer | `Alt + w` (or `:bc`) |
| Next buffer | `Tab` (or `]b`, `gn`) |
| Previous buffer | `Shift + Tab` (or `[b`, `gp`) |
| Command palette | `Alt + x` (or `Space + ?`) |

### Window Splits
| Action | Shortcut |
| :--- | :--- |
| Split vertical (side-by-side) | `Ctrl + w` then `v` |
| Split horizontal (top/bottom) | `Ctrl + w` then `s` |
| Focus a split | Left-click with mouse, or `Ctrl + w` then `h`/`j`/`k`/`l` |
| Close focused split | `Ctrl + w` then `q` |
| Close all other splits | `Ctrl + w` then `o` |
| Open picker file in split | Press `Ctrl + v` (vertical) or `Ctrl + s` (horizontal) inside file picker |

### Git
| Action | Shortcut |
| :--- | :--- |
| Changed and staged files | `Space + g` |
| Next diff hunk | `]g` |
| Previous diff hunk | `[g` |
| Terminal Git interface | Open terminal split → run `lg` (lazygit) |

### Code Intelligence (LSP)
| Action | Shortcut |
| :--- | :--- |
| Go to definition | `F12` (or `gd`) |
| Jump back | `Ctrl + o` |
| Jump forward | `Ctrl + i` |
| Type and doc hover | `Space + k` (or `K`) |
| Find references | `Shift + F12` (or `gr`) |
| File outline | `Space + s` |
| Workspace symbols | `Space + S` |
| Project-wide rename | `F2` (or `Space + r`) |
| Quick fix / code actions | `Space + a` |
| Next / previous diagnostic | `]d` / `[d` |
| Project diagnostics list | `Space + d` |

---

## 4. Buffers, Tabs, and Mouse Handling

### The Bufferline
The top bar displays open buffers.

> [!NOTE]
> Helix runs in the terminal. The bufferline is a text status display rendered by Helix; the terminal does not convert mouse clicks on this line into buffer events. Mouse clicks are handled only inside active text panes.

* **Switch buffers sequentially**: Press `Tab` for next, `Shift + Tab` for previous.
* **Switch by name**: Press `Space + b`, type part of the file name, and press `Enter`.
* **Close a buffer**: Press `Alt + w` or type `:bc` and press `Enter`. To discard unsaved changes, use `:bc!`.

---

## 5. Movement and Navigation

### Cursor Movement
* `h`, `j`, `k`, `l` or arrow keys: Left, Down, Up, Right.
* **Mouse**: Left-click sets cursor position. Click and drag selects text. Mouse wheel scrolls.

### Word Motions
* `w`: Select to start of next word.
* `b`: Select to start of previous word.
* `e`: Select to end of current/next word.

### Line Motions
* `x`: Select current line. Press `x` again to add the next line to the selection.
* `gh`: Move to line start.
* `gl`: Move to line end.
* `gs`: Move to first non-whitespace character.

### Document Motions
* `gg`: Go to first line of file.
* `ge`: Go to last line of file.
* `:123` then `Enter`: Jump directly to line 123.
* `Ctrl + d`: Scroll half-page down.
* `Ctrl + u`: Scroll half-page up.

---

## 6. Editing Actions

Once text is selected:

| Key | Action | Description |
| :--- | :--- | :--- |
| `i` | Insert | Enters Insert mode before the selection |
| `a` | Append | Enters Insert mode after the selection |
| `I` | Insert at line start | Moves to first non-blank character of line and enters Insert mode |
| `A` | Append at line end | Moves to line end and enters Insert mode |
| `o` | Open line below | Inserts empty line below and enters Insert mode |
| `O` | Open line above | Inserts empty line above and enters Insert mode |
| `c` | Change | Deletes selection and enters Insert mode |
| `d` | Delete | Deletes selection and copies it to default register |
| `y` | Yank | Copies selection |
| `p` | Paste after | Pastes copied text after cursor/selection |
| `P` | Paste before | Pastes copied text before cursor/selection |
| `u` | Undo | Reverts previous change |
| `U` | Redo | Reapplies undone change |
| `Ctrl + c` | Toggle comment | Comments or uncomments selected lines |
| `>` / `<` | Indent / unindent | Shifts selected lines right or left |

---

## 7. Text Objects (Match Mode `m`)

Match mode (`m`) selects text between enclosing pairs like quotes, brackets, or function bodies:

| Keys | What it selects | Example |
| :--- | :--- | :--- |
| `mi"` | Inside double quotes | `"sample text"` → selects `sample text` |
| `ma"` | Around double quotes | `"sample text"` → selects `"sample text"` |
| `mi'` | Inside single quotes | `'token'` → selects `token` |
| `mi(` or `mi)` | Inside parentheses | `func(arg1, arg2)` → selects `arg1, arg2` |
| `ma(` or `ma)` | Around parentheses | `func(arg1, arg2)` → selects `(arg1, arg2)` |
| `mi{` or `mi}` | Inside braces | `{ key: value }` → selects ` key: value ` |
| `ma{` or `ma}` | Around braces | `{ key: value }` → selects `{ key: value }` |
| `mi[` or `mi]` | Inside brackets | `[1, 2, 3]` → selects `1, 2, 3` |
| `mif` | Inside function | Selects the body of the enclosing function |
| `maf` | Around function | Selects the full function definition |

### Common Replacement Sequence
1. Place cursor inside the quotes or brackets.
2. Press `mi"` (or `mi(`, `mi{`).
3. Press `c` to delete the inner content and enter Insert mode.
4. Type the new text and press `Esc`.

---

## 8. Multi-Cursors and Regex Selection

Helix supports multiple selections natively:

* **Select matches across a block or file**:
  1. Select lines with `x`, or select the whole file with `%`.
  2. Press `s` (select by regex).
  3. Type the search string (e.g. `userId`) and press `Enter`.
  4. Each match becomes an active cursor.
  5. Press `c` to edit all matches at once, or `d` to delete them.
* **Add cursor to next line**: Press `C` (uppercase).
* **Split multi-line selection into one cursor per line**: Press `Alt + s`.
* **Clear extra cursors**: Press `,` (comma) to keep only the primary cursor.

---

## 9. Running Terminals, Shell Commands, and Dev Servers

Helix does not contain an embedded terminal. Use these four methods depending on the task:

### 1. Ghostty Terminal Splits (Dev Servers and Watchers)
* Press `Cmd + Shift + D` to open a terminal split below Helix.
* Press `Cmd + D` to open a split to the right.
* Run long-running processes like `pnpm dev`, `cargo watch`, or tests.
* Press `Cmd + Shift + Enter` to toggle the active pane fullscreen.
* Switch panes by clicking with the mouse or pressing `Cmd + [` and `Cmd + ]`.
* Close the terminal pane with `Ctrl + d` or `exit`.

### 2. Tmux Panes (When Inside Tmux)
* Split below: `Ctrl + a` then `-`
* Split right: `Ctrl + a` then `|`
* Toggle pane zoom: `Ctrl + a` then `z`
* Navigate panes: `Ctrl + a` followed by arrow keys or `h`/`j`/`k`/`l`

### 3. Suspend and Resume (`Ctrl + z` / `fg`)
For a quick command in your shell:
1. In Helix, press `Ctrl + z`.
2. Helix suspends to the background, returning to Fish shell.
3. Run your command (`git diff`, `pnpm build`, etc.).
4. Type `fg` and press `Enter`.
5. Helix resumes with open buffers and cursor positions preserved.

### 4. Direct Shell Commands in Helix
* `:sh <command>`: Runs command and displays output in a status popup (e.g. `:sh pnpm test`).
* `! <command>`: Runs command and inserts its output at cursor position.
* `| <command>`: Pipes selected text into a shell command and replaces the selection with command output.
  * Example: Select JSON lines → `| jq .` → replaces selection with formatted JSON.
  * Example: Select unordered list → `| sort -u` → replaces selection with sorted unique lines.

---

## 10. Code Intelligence and Refactoring

### Definition Navigation and Hover
* Move cursor to a function or variable (or left-click it).
* Press `F12` (or `gd`) to jump to definition.
* Press `Ctrl + o` to jump back to where you came from.
* Press `Space + k` (or `K`) to view type information and docstrings. Press `Esc` to close.

### Project-Wide Semantic Rename
To rename a symbol across all files in the project:
1. Move cursor to the variable, function, or class name.
2. Press `F2` (or `Space + r`).
3. Type the new name in the bottom prompt and press `Enter`.
4. The Language Server renames the symbol across all referencing files.
5. Affected files are updated in memory and marked with `[+]` in the bufferline.
6. Type `:wa` and press `Enter` to write all modified files to disk.

---

## 11. Language Servers and Format on Save

Format on save is enabled. Pressing `Ctrl + s` (or running `:w`) formats the buffer through the configured tool:

| Language | LSP | Formatter |
| :--- | :--- | :--- |
| TypeScript / JavaScript | `oxlint`, `typescript-language-server` | `oxfmt` |
| HTML / CSS / JSON | `vscode-langservers-extracted` | `oxfmt` |
| Markdown / YAML | Built-in Tree-Sitter, `yaml-language-server` | `oxfmt` |
| Python | `pyright`, `ruff` | `ruff` |
| Go | `gopls` | `gopls` |
| Rust | `rust-analyzer` | `rustfmt` |
| Swift | `sourcekit-lsp` | `swift-format` |
| TOML | `taplo` | `taplo` |

---

## 12. Theme Configuration (Non-Italic Comments)

The dotfiles use the Tomorrow Night Blue palette (`#002451` background).

Comments are styled as plain text in [`configs/helix/.config/helix/themes/tomorrow_night_blue.toml`](file:///Users/nikita/Projects/.dotfiles/configs/helix/.config/helix/themes/tomorrow_night_blue.toml):

```toml
"comment" = { fg = "selection" }
```

To enable italics, add the modifier:
```toml
"comment" = { fg = "selection", modifiers = ["italic"] }
```

Other available modifiers are `"bold"`, `"dim"`, and `"underlined"`.

---

## 13. Practical Walkthrough Scenarios

### Scenario A: Replace Function Arguments
1. Click inside `calculateTotal(items, discountRate)`.
2. Press `mi(`. The text `items, discountRate` is selected.
3. Press `c`.
4. Type `orderItems`.
5. Press `Esc`.

### Scenario B: Delete Multiple Lines
1. Move cursor to first line to delete.
2. Press `x` to select the line.
3. Press `x` again for each additional line you want to include.
4. Press `d` to delete the selected block.

### Scenario C: Review Changed Git Files and Edit in a Split
1. Press `Space + g` to open the Git status list.
2. Use `j`/`k` to select a modified file.
3. Press `Ctrl + v`.
4. The modified file opens in a vertical split beside your current buffer.
5. Press `]g` to jump to the first diff hunk.

### Scenario D: Rename a Component across the Project
1. Put cursor on `UserProfile` component declaration.
2. Press `F2`.
3. Type `AccountProfile` and press `Enter`.
4. Check the buffer list with `Space + b` to see all updated files.
5. Type `:wa` and press `Enter` to save changes across all files.

### Scenario E: Format and Sort an Array or JSON Block
1. Select the lines with `x`.
2. Press `|`.
3. Type `sort` (or `jq .`) and press `Enter`.
4. The output replaces the selected lines.

---

## 14. Built-in Tutor

Helix includes an interactive tutorial to practice motions directly in the editor:

```sh
hx --tutor
```
