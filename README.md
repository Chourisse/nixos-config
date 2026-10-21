## Commandes

| Commande | Action |
|---|---|
| `rs` | `nixos-rebuild switch` (applique la config) |
| `sc` | commit "Update" + pull + push sur GitHub |
| `tg` | `topgrade` (met tout à jour) |
| `ff` | `fastfetch` |

## Raccourcis clavier

### Shell Caelestia

| Raccourci | Action |
|---|---|
| `Super` (appui bref) / `Super+Espace` | Launcher |
| `Super+N` | Barre latérale / notifications |
| `Super+K` | Afficher tous les panneaux |
| `Ctrl+Alt+Delete` | Menu session |
| `Super+L` | Verrouiller l'écran |
| `Super+Maj+L` | Mise en veille |

### Fenêtres

| Raccourci | Action |
|---|---|
| `Super+F` | Plein écran |
| `Super+Alt+F` | Maximiser |
| `Super+Q` | Fermer la fenêtre |

### Tiroirs (workspaces spéciaux)

| Raccourci | Action |
|---|---|
| `Ctrl+Maj+Échap` | Moniteur système (btop) |

### Applications

| Raccourci | Action |
|---|---|
| `Super+Z` | Terminal (kitty) |
| `Super+W` | Navigateur (LibreWolf) |
| `Super+E` | Gestionnaire de fichiers (Dolphin) |
| `Super+S` | Steam |

### Captures et enregistrement

| Raccourci | Action |
|---|---|
| `Super+Maj+Alt+S` | Capture (sélection) |

### Presse-papiers et emoji

| Raccourci | Action |
|---|---|
| `Super+V` | Historique du presse-papiers (cliphist + fuzzel) |
| `Super+.` | Sélecteur d'emoji |

## Installation

```fish
git clone https://github.com/Chourisse/nixos-config /etc/nixos
cd /etc/nixos
sudo nixos-rebuild switch --flake .#NixOS
```
