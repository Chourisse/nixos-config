# Migration KDE Plasma → Hyprland + Caelestia

Branche `hyprland-caelestia`. La branche `main` (Plasma) est intacte : rollback
en une commande si besoin.

**Le nouvel environnement, en résumé**

| Rôle | Avant (Plasma) | Après |
|---|---|---|
| Compositeur / WM | KWin | Hyprland (session UWSM, config Lua) |
| Shell de bureau | Plasma | **Caelestia** (QuickShell) : barre, launcher, notifs, OSD, centre de contrôle, lockscreen |
| Écran de login | SDDM + autologin | greetd + ReGreet stylé façon Caelestia (pas d'autologin) |
| Fichiers | Dolphin | Thunar (+ gvfs/tumbler) |
| Captures | Spectacle | intégré Caelestia (touche `Impr. écran`) |
| Trousseau | KWallet | GNOME Keyring (déverrouillé au login, GUI : Seahorse) |
| Partitions | KDE Partition Manager | GParted |
| Images / archives / vidéo | Gwenview / Ark / … | imv / File Roller / mpv (HDR) |
| Idle / lock | KScreenLocker | intégré Caelestia (lock 10 min, écrans off 15 min, **pas de mise en veille auto**) |
| Presse-papiers | Klipper | cliphist + sélecteur Caelestia (`Super+V`) |

Le reste ne bouge pas : kernel CachyOS, mesa-git, Steam/gamemode/gamescope_git,
PipeWire, fish/kitty, btrbk, LACT, Mullvad, lanzaboote…

---

## 1. Avant de basculer

1. **(Optionnel, pendant que Plasma est encore là)** — les mots de passe stockés
   dans KWallet ne suivent pas dans GNOME Keyring. Si des applications y ont des
   secrets importants, exporte-les depuis KWalletManager. Sinon, les applis
   redemanderont leurs identifiants une première fois.
2. Récupère la branche dans `/etc/nixos` :

   ```bash
   cd /etc/nixos
   git fetch origin
   git checkout hyprland-caelestia
   ```

3. Le `flake.lock` de la branche est déjà à jour et inclut le nouvel input
   `caelestia-shell` (la config Lua requiert Hyprland ≥ 0.55 et un Home Manager
   récent). Un `nix flake update` reste possible si tu veux les tous derniers
   correctifs, mais il n'est pas nécessaire pour basculer.

4. **Build à blanc, encore sous Plasma** (attrape les erreurs sans casser la session) :

   ```bash
   sudo nixos-rebuild build --flake /etc/nixos#NixOS
   ```

5. Bascule en TTY (`Ctrl+Alt+F3`, reconnecte-toi en console) — le switch tue
   SDDM, donc la session Plasma avec :

   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#NixOS
   sudo reboot
   ```

**Rollback** : choisis la génération précédente dans le menu lanzaboote, ou
`git checkout main` puis ton alias `rs`.

---

## 2. Premier boot

1. ReGreet s'affiche. Connecte-toi **en choisissant la session
   « Hyprland (uwsm-managed) »** (pas « Hyprland » tout court). ReGreet retient
   le choix ensuite. Le mot de passe déverrouille aussi GNOME Keyring.
2. Vérifie les écrans dans un terminal (`Super+T`) :

   ```bash
   hyprctl monitors all
   ```

   L'écran principal doit être en `2560x1440@359.x`, position `1920x0`.
   La config l'identifie par description EDID
   (`desc:Gigabyte Technology Co., Ltd.`, idem `Iiyama` / `CHiQ` pour les
   secondaires). **Si un nom de fabricant ne matche pas dans l'EDID réel**,
   l'écran tombera sur la règle de secours (il s'allume, mais sans
   360 Hz/HDR/position) : relève alors le début de sa `description:` dans la
   sortie de `hyprctl` et corrige-le dans `home/hypr/01-monitors.lua`, puis `rs`.
   Si gauche/droite sont inversés : échange les deux blocs 1080p dans le même
   fichier.
3. **Fond d'écran** : dépose des images dans `~/Pictures/Wallpapers`, tape
   brièvement `Super` (launcher), écris `>wallpaper` et choisis. Caelestia en
   déduit tout le schéma de couleurs Material (shell + kitty).
4. **Avatar** du dashboard/lock : copie une image vers `~/.face`.
5. **Météo** : réglages Caelestia (Nexus) → services → localisation
   (ou `services.weatherLocation` dans `~/.config/caelestia/shell.json`).

---

## 3. HDR : comment c'est réglé

Stratégie « auto fullscreen » (celle que tu as choisie) :

- Écran principal en **10 bit** + `cm = "auto"` (large gamut) en permanence :
  bureau SDR propre, sans le voile délavé du HDR permanent.
- `render.cm_auto_hdr = 1` : dès qu'un contenu HDR passe en **plein écran**,
  Hyprland bascule la sortie en HDR PQ (primaires BT.2020), et revient tout
  seul en SDR en quittant le plein écran.
- `vrr = 3` : VRR uniquement pour le plein écran jeu/vidéo (pas de
  scintillement VRR OLED sur le bureau).
- `quirks.prefer_hdr = 2` : annonce le HDR comme préféré à gamescope.

**Tester**

- Vidéo : `mpv --fullscreen un_fichier_hdr.mkv` (le `mpv.conf` fourni laisse
  Hyprland gérer la bascule). L'OSD de l'écran doit afficher le mode HDR.
- Jeu (options de lancement Steam, via ton `gamescope_git`) :

  ```
  gamescope -W 2560 -H 1440 -r 360 --hdr-enabled --adaptive-sync -f -- %command%
  ```

  L'option HDR du jeu doit devenir disponible. Sans gamescope, les jeux en
  plein écran natif qui émettent du HDR déclenchent aussi la bascule, mais
  gamescope reste le chemin le plus fiable sous Proton.

**Réglages si besoin** (`home/hyprland.nix` et `home/hypr/01-monitors.lua`)

- Couleurs HDR qui semblent fausses → `cm_auto_hdr = 2` (primaires EDID de
  l'écran au lieu de BT.2020).
- Écran noir bref à la bascule : normal (renégociation du mode), quelques
  centaines de ms.
- 360 Hz absent des modes → vérifier câble DP 1.4 (HBR3) et essayer un autre
  port DP du GPU ; le 1440p360 10 bit passe par DSC.
- HDR **permanent** (si tu changes d'avis) : dans le bloc de l'écran
  principal, `cm = "hdr"` + `sdrbrightness = 1.2`, `sdrsaturation = 0.98` à
  ajuster à l'œil.
- Captures d'écran/OBS pendant qu'une surface HDR est active : le rendu peut
  paraître sombre/délavé (limitation actuelle de l'écosystème 10 bit). Le
  bureau SDR, lui, se capture normalement.

---

## 4. Aide-mémoire des raccourcis

Base « Caelestia » adaptée à tes applis — liste complète commentée dans
`home/hypr/04-binds.lua`.

| Touche | Action |
|---|---|
| `Super` (appui bref) ou `Super+Espace` | Launcher |
| `Super+T` / `Super+W` / `Super+C` / `Super+E` / `Super+G` | kitty / Librewolf / Neovim / Thunar / Steam |
| `Super+Q` | Fermer la fenêtre |
| `Super+1…0` | Aller au workspace (de l'écran courant) |
| `Super+Alt+1…0` | Envoyer la fenêtre au workspace |
| `Super+←→↑↓` / `+Maj` | Focus / déplacer la fenêtre |
| `Super+F` / `Super+Alt+F` | Plein écran / maximisé |
| `Super+Alt+Espace` | Bascule flottant |
| `Super` + glisser (souris) | Déplacer ; bouton droit : redimensionner |
| `Super+L` | Verrouiller |
| `Super+N` | Barre latérale (notifs, calendrier…) |
| `Super+K` | Afficher tous les panneaux |
| `Super+V` / `Super+.` | Historique presse-papiers / emoji |
| `Impr. écran` / `Super+Maj+S` | Capture / capture région figée |
| `Ctrl+Alt+R` | Enregistrement d'écran (Caelestia) |
| `Ctrl+Maj+Échap` | Tiroir btop (moniteur système) |
| `Super+M` / `Super+D` / `Super+R` / `Super+S` | Tiroirs musique / comm / todo / générique |
| `Ctrl+Alt+ Suppr` | Menu de session (éteindre, redémarrer…) |
| `Super+Alt+L` | Redémarrer le shell Caelestia |

**Workspaces multi-écran** : ils sont groupés par dizaines, un groupe par
écran. `Super+3` = 3ᵉ workspace de l'écran où tu es ; `Ctrl+Super+3` change de
groupe. C'est la logique native de Caelestia, la barre la reflète.

---

## 5. Personnalisation

- **Caelestia** : `~/.config/caelestia/shell.json` a été **copié une seule fois**
  depuis `home/caelestia/shell.json` du repo (apps par défaut, idle lock 10 min /
  écrans 15 min, empreinte/Howdy désactivés). Ensuite il est à toi : règle tout
  depuis l'interface Nexus, ça s'enregistre normalement. Si tu veux rendre un
  réglage déclaratif plus tard, recopie-le dans le seed du repo… ou supprime le
  fichier puis relance un `rs` pour repartir du seed.
- **kitty** : même principe pour `~/.config/kitty/kitty.conf` (police
  JetBrainsMono Nerd Font + `include theme.conf` que la CLI Caelestia remplit
  à chaque fond d'écran).
- **Hyprland** : réglages « données » dans `home/hyprland.nix` (générés dans
  `hyprland.lua`), logique en Lua pur dans `home/hypr/*.lua`. C'est là que se
  règlent écrans, binds et règles de fenêtres. Rebuild avec `rs`.
- **Bordures** : couleurs fixes dans `home/hyprland.nix` (le shell se recolore
  tout seul, pas les bordures du compositeur — compromis assumé v1).
- **Clavier** : layout `us` conservé comme avant. Pour passer en AZERTY :
  `kb_layout = "fr"` dans `home/hyprland.nix` — attention, les binds lettre
  (Q, W, A…) suivent les *keysyms*, il faudra adapter ceux de
  `home/hypr/04-binds.lua` à ton goût.
- **Greeter** : thème/CSS dans `modules/desktop.nix` (bloc ReGreet).

---

## 6. Dépannage

- **Pas de session dans ReGreet / mauvais choix** : vérifier que
  « Hyprland (uwsm-managed) » est sélectionnée.
- **Shell invisible ou planté** : `Super+Alt+L` (restart du service), sinon
  `systemctl --user status caelestia` et `journalctl --user -u caelestia -e`.
  Le service est en `Restart=on-failure`.
- **Écran verrouillé sans shell pour déverrouiller** : passe en TTY
  (`Ctrl+Alt+F3`), connecte-toi, `systemctl --user restart caelestia` : grâce à
  `allow_session_lock_restore`, le lockscreen réapparaît.
- **Écran principal pas en 360 Hz / mauvaise position** : voir §2.2 (descriptions EDID).
- **Luminosité des écrans externes inopérante** : c'est du DDC/CI — vérifier que
  l'option est activée dans l'OSD des moniteurs ; test manuel : `ddcutil detect`.
- **Retour Plasma complet** : génération précédente dans lanzaboote, ou
  `git checkout main && rs`.

## 7. Nettoyage (optionnel, après quelques jours de validation)

Résidus de configuration KDE devenus inutiles (à inspecter avant suppression) :

```bash
ls ~/.config | grep -iE 'plasma|kde'
# candidats typiques : ~/.config/plasma*, ~/.config/kdeglobals,
# ~/.local/share/plasma, ~/.local/share/kwalletd (après export éventuel !)
```

Rien ne presse : ils n'ont aucun effet sur la nouvelle session.
