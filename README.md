# NixOS — Hyprland + Caelestia

Configuration NixOS (flake) de mon PC : **Hyprland 0.56** (parser Lua) + **Caelestia Shell** (QuickShell), avec Secure Boot (Lanzaboote), BTRFS + snapshots horaires (btrbk), stack gaming AMD (mesa-git, noyau CachyOS, Steam, Gamemode).

**Matériel**
- Gigabyte MO27Q3 — QD-OLED 27" 2560x1440@360 (principal, à droite)
- Iiyama PL2245H 1080p@100 (haut-gauche) + CHiQ 1080p@100 (bas-gauche)
- GPU AMD, clavier QWERTY US avec knob de volume

## Commandes

| Commande | Action |
|---|---|
| `rs` | `nixos-rebuild switch` (applique la config) |
| `sc` | commit "Update" + pull + push sur GitHub |
| `tg` | `topgrade` (met tout à jour) |
| `ff` | `fastfetch` |

## Raccourcis

### Shell Caelestia

| Raccourci | Action |
|---|---|
| `Super` (appui bref) / `Super+Espace` | Launcher |
| `Super+N` | Barre latérale / notifications |
| `Super+K` | Afficher tous les panneaux |
| `Ctrl+Alt+Delete` | Menu session |
| `Super+L` | Verrouiller l'écran |
| `Super+Maj+L` | Mise en veille |
| `Super+Alt+L` | Redémarrer le shell |
| `Ctrl+Super+Alt+R` | Redémarrer le shell |
| `Ctrl+Super+Maj+R` | Tuer le shell |
| `Ctrl+Alt+C` | Effacer les notifications |

### Workspaces

| Raccourci | Action |
|---|---|
| `Super+1…0` | Aller au workspace N |
| `Super+Alt+1…0` | Déplacer la fenêtre vers le workspace N |
| `Ctrl+Super+1…0` | Workspace N du groupe (écran) suivant |
| `Ctrl+Super+Alt+1…0` | Fenêtre vers workspace N du groupe suivant |
| `Super+Page Up/Down` · `Ctrl+Super+←/→` · `Super+molette` | Workspace précédent / suivant |
| `Ctrl+Super+molette` | Groupe (écran) précédent / suivant |
| `Super+Alt+Page Up/Down` · `Super+Alt+molette` | Fenêtre vers workspace précédent / suivant |
| `Super+Alt+S` | Fenêtre vers le tiroir |
| `Ctrl+Super+Maj+↓` | Sortir la fenêtre du tiroir |

### Fenêtres

| Raccourci | Action |
|---|---|
| `Super+←/→/↑/↓` | Déplacer le focus |
| `Super+Maj+←/→/↑/↓` | Déplacer la fenêtre |
| `Alt+Tab` / `Maj+Alt+Tab` | Fenêtre suivante / précédente |
| `Ctrl+Alt+Tab` / `Ctrl+Maj+Alt+Tab` | Onglet suivant / précédent (groupe) |
| `Super+,` | Grouper / séparer (onglets) |
| `Super+Maj+,` | Verrouiller le groupe |
| `Super+U` | Sortir la fenêtre du groupe |
| `Super+-` / `Super+=` | Rétrécir / élargir la fenêtre |
| `Super+Maj+-` / `Super+Maj+=` | Réduire / augmenter la hauteur |
| `Super+Alt+←/→/↑/↓` | Redimensionner (clavier) |
| `Super+clic gauche` | Déplacer la fenêtre |
| `Super+clic droit` | Redimensionner la fenêtre |
| `Ctrl+Super+\` | Centrer la fenêtre |
| `Ctrl+Super+Alt+\` | Taille "normale" (55% x 70%) centrée |
| `Super+Alt+\` | Mode Picture-in-picture épinglé |
| `Super+P` | Épingler la fenêtre |
| `Super+F` | Plein écran |
| `Super+Alt+F` | Maximiser |
| `Super+Alt+Espace` | Flotter / tuiler |
| `Super+Q` | Fermer la fenêtre |

### Tiroirs (workspaces spéciaux)

| Raccourci | Action |
|---|---|
| `Super+S` | Tiroir générique (ouvrir/fermer) |
| `Ctrl+Maj+Échap` | Moniteur système (btop) |
| `Super+M` | Musique |
| `Super+D` | Communication |
| `Super+R` | Todo |

### Applications

| Raccourci | Action |
|---|---|
| `Super+T` | Terminal (kitty) |
| `Super+C` | Neovim (kitty) |
| `Super+W` | Navigateur (LibreWolf) |
| `Super+E` | Gestionnaire de fichiers (Dolphin) |
| `Super+G` | Steam |
| `Ctrl+Alt+V` | Mixer audio (pwvucontrol) |

### Captures et enregistrement

| Raccourci | Action |
|---|---|
| `Impr écran` | Capture d'écran |
| `Super+Maj+S` | Capture figée (sélection) |
| `Super+Maj+Alt+S` | Capture (sélection) |
| `Ctrl+Alt+R` | Enregistrement d'écran |
| `Super+Alt+R` | Enregistrement (sélection) |
| `Super+Maj+Alt+R` | Enregistrement (écran) |
| `Super+Maj+C` | Pipette à couleurs (hyprpicker) |

### Son, média, luminosité

| Raccourci | Action |
|---|---|
| `Super+Maj+M` / touche mute | Couper le son |
| Touche mic mute | Couper le micro |
| Knob / touches volume | Volume **par pas de 1%** |
| Touches média (play/next/prev/stop) | Lecture média (Bluetooth inclus via mpris-proxy) |
| `Ctrl+Super+Espace` / `=` / `-` / `Retour arrière` | Même chose au clavier |
| Touches luminosité | Luminosité de l'écran (ddcutil) |

### Presse-papiers et emoji

| Raccourci | Action |
|---|---|
| `Super+V` | Historique du presse-papiers (cliphist + fuzzel) |
| `Super+Alt+V` | Supprimer une entrée |
| `Super+.` | Sélecteur d'emoji |

## Structure

```
configuration.nix        entrée NixOS
hardware-configuration.nix
flake.nix / flake.lock
modules/                 boot, hardware, network, locale, desktop, gaming, nix, users
home.nix                 paquets et réglages utilisateur
home/hyprland.nix        config Hyprland (settings)
home/hypr/               animations, moniteurs, env, règles, raccourcis, autostart
home/caelestia.nix       Caelestia Shell (+ CLI avec ffmpeg)
home/caelestia/shell.json
home/kitty.conf
```

## Installation

```fish
git clone https://github.com/Chourisse/nixos-config /etc/nixos
cd /etc/nixos
sudo nixos-rebuild switch --flake .#NixOS
```
