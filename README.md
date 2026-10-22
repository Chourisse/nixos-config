## Commands

| Command | Action |
|---|---|
| `rs` | `nixos-rebuild switch` (applies the config) |
| `sc` | commit "Update" + pull + push to GitHub |
| `tg` | `topgrade` (updates everything) |
| `ff` | `fastfetch` |

## Keyboard shortcuts

### Caelestia shell

| Shortcut | Action |
|---|---|
| `Super` (short press) / `Super+Space` | Launcher |
| `Super+N` | Sidebar / notifications |
| `Super+K` | Show all panels |
| `Ctrl+Alt+Delete` | Session menu |
| `Super+L` | Lock screen |
| `Super+Shift+L` | Sleep |

### Windows

| Shortcut | Action |
|---|---|
| `Super+F` | Fullscreen |
| `Super+Alt+F` | Maximize |
| `Super+Q` | Close window |
| `Super` + left click (hold) | Move window |

### Drawers (special workspaces)

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+Esc` | System monitor (btop) |

### Applications

| Shortcut | Action |
|---|---|
| `Super+Z` | Terminal (kitty) |
| `Super+W` | Browser (LibreWolf) |
| `Super+E` | File manager (Dolphin) |
| `Super+S` | Steam |

### Screenshots and recording

| Shortcut | Action |
|---|---|
| `Super+Shift+Alt+S` | Screenshot (selection) |

### Clipboard and emoji

| Shortcut | Action |
|---|---|
| `Super+V` | Clipboard history (cliphist + fuzzel) |
| `Super+.` | Emoji picker |

## Installation

```fish
git clone https://github.com/Chourisse/nixos-config /etc/nixos
cd /etc/nixos
sudo nixos-rebuild switch --flake .#NixOS
```
