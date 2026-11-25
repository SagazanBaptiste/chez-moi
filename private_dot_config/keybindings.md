# Keyboard Binding Manifest

This file is the source of truth for ergonomic AZERTY bindings. Each
application owns its bindings so that contextual help remains accurate.

## Rules

- Keep native Vim letter bindings when they are ergonomic: `h`, `j`, `k`, `l`,
  `w`, `b`, `e`, `f`, `t`, `n`, and `N`.
- Remap difficult AZERTY symbols per application.
- Do not remap printable keys globally at the terminal or OS level.
- Record conflicts before assigning a binding.
- Prefer mnemonic bindings over reproducing the QWERTY layout physically.

## Preferred Intentions

| Intention | Preferred binding | Native Vim input |
|---|---|---|
| Move left | `h` | `h` |
| Move down | `j` | `j` |
| Move up | `k` | `k` |
| Move right | `l` | `l` |
| Search forward | `Alt+f` | `/` |
| Search backward | `Alt+Shift+f` | `?` |
| Start of line | `a-grave` | `0` |
| Previous paragraph or context | `Alt+k` | `{` |
| Next paragraph or context | `Alt+j` | `}` |
| Previous-prefix commands | `Alt+h` | `[` |
| Next-prefix commands | `Alt+l` | `]` |

`a-grave` means the unshifted key on the physical `0` position of a classic
French AZERTY layout.

## Application Inventory

| Application | Configuration | Status |
|---|---|---|
| Ghostty | `~/.config/ghostty/config` | Configured |
| Lazygit | `~/.config/lazygit/config.yml` | Partially configured |
| Zsh | `~/.zshrc` | Vi mode configured |
| Starship | `~/.config/starship.toml` | Normal-mode indicator configured |
| Neovim | `~/.config/nvim/` | Configured |
| Yazi | `~/.config/yazi/keymap.toml` | Not found |

## Ghostty

Current split bindings:

| Action | Binding |
|---|---|
| Create right split | `Ctrl+Alt+d` |
| Create lower split | `Ctrl+Alt+Shift+d` |
| Focus left split | `Ctrl+Alt+h` |
| Focus right split | `Ctrl+Alt+l` |
| Focus upper split | `Ctrl+Alt+k` |
| Focus lower split | `Ctrl+Alt+j` |
| Toggle split zoom | `Ctrl+Alt+Enter` |

### Reserved Namespace

`Ctrl+Alt` is reserved for Ghostty. Plain `Alt` combinations remain available
to child applications such as Lazygit, Zsh, and Neovim.

## Lazygit

Current custom bindings:

| Action | Binding | Effective? |
|---|---|---|
| Previous item | `k` | Yes |
| Next item | `j` | Yes |
| Previous block | `h` | Yes |
| Next block | `l` | Yes |
| Search | `Alt+f` | Yes |
| Previous page | `Alt+k` | Yes |
| Next page | `Alt+j` | Yes |
| Previous tab | `Alt+Left` | Yes |
| Next tab | `Alt+Right` | Yes |
| Cycle pagers | `Alt+p` | Yes |
| Extras menu | `Ctrl+x` | Yes |
| Decrease diff context | `Alt+Down` | Yes |
| Increase diff context | `Alt+Up` | Yes |
| Toggle file tree | `t` | Yes |
| Previous hunk | `h` | Yes |
| Next hunk | `l` | Yes |

## Zsh

Zsh uses ZLE vi mode:

```zsh
bindkey -v
export KEYTIMEOUT=5
```

In `vicmd`, Zsh already provides:

| Action | Native binding |
|---|---|
| Cursor movement | `h`, `j`, `k`, `l` |
| Word movement | `w`, `b`, `e` |
| Start of line | `0` |
| End of line | `$` |
| Search older history | `/` |
| Search newer history | `?` |
| Repeat search | `n`, `N` |

Configured AZERTY addition:

```zsh
# Physical 0 key without Shift, command mode only.
bindkey -M vicmd $'\u00e0' beginning-of-line
```

Starship displays `NORMAL` while the `vicmd` keymap is active. There is no
custom help binding; use `bindkey -M vicmd` to inspect Zsh bindings.

Do not reproduce the paragraph and bracket mappings in Zsh. ZLE edits a shell
command buffer rather than a document, and `{`, `}`, `[`, and `]` have no native
motion in its `vicmd` keymap.

Keep the existing FZF bindings where available:

| Action | Binding |
|---|---|
| Search command history | `Ctrl+r` |
| Select a file | `Ctrl+t` |
| Change directory | `Alt+c` |

## Neovim

Neovim uses `Space` as its leader. Pressing `Space` and waiting briefly opens
WhichKey, which lists the available continuations and their descriptions.

AZERTY additions:

| Action | Binding |
|---|---|
| Start of line | `à` |
| Search forward | `Alt+f` |
| Search backward | `Alt+Shift+f` |
| Previous paragraph | `Alt+k` |
| Next paragraph | `Alt+j` |
| Return to normal mode from insert | `jj` |
| Join lines in normal / visual mode | `Alt+Shift+j` (`J` disabled) |
| Toggle file-tree sidebar | `Space e` |
| Filter recursively inside the tree | `Alt+f` or `/` |
| Expand / collapse a directory in the tree | `l` / `h` or Right / Left |
| Toggle automatic file preview in the tree | `P` |
| Search files in current directory / whole project | `Space s f` / `Space s F` |
| Search text in current directory / whole project | `Space s g` / `Space s G` |
| Add / edit project file bookmarks | `Space b a` / `Space b m` |
| Jump to file bookmark | `Space b 1` through `Space b 5` |
| Toggle quickfix / send diagnostics | `Space x q` / `Space x d` |
| Next / previous quickfix result | `Space x n` / `Space x p` |
| Next / previous function | `Space l j` / `Space l k` |
| Function definition/body; class/body textobjects | `aF` / `iF`; `ac` / `ic` |
| Git review / revision comparison | `Space g d` / `Space g D` |
| File / project history | `Space g h` / `Space g H` |
| Git review panel focus / toggle | `Space g v` / `Space g V` |
| Close Git review | `Space g q` |

Main namespaces:

| Prefix | Purpose |
|---|---|
| `Space s` | Search and navigation |
| `Space b` | Buffers and project file bookmarks |
| `Space g` | Git search, review, and history |
| `Space x` | Quickfix results and diagnostics |
| `Space l` | LSP and code actions |
| `Space t` | Tests |
| `Space d` | Debugger |
| `Space r` | Run tasks and code |
| `Space w` | Editor windows |
| `Space u` | UI toggles |

Use `:NvimGuide` for the complete local cheat sheet and `:Tutor` for the
built-in interactive tutorial.

## Pending Decisions

- Revisit mappings only after a real-project trial period.
