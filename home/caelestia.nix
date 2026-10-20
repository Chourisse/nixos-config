{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  # Module Home Manager officiel de Caelestia (option programs.caelestia)
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.caelestia = {
    enable = true;

    # Paquets nixpkgs (cache binaire, polices et dépendances d'exécution
    # déjà intégrées) plutôt que les builds du flake amont.
    # Pour revenir aux builds du flake, supprimez ces deux lignes.
    package = pkgs.caelestia-shell;
    cli.package = pkgs.caelestia-cli;
    cli.enable = true;

    # Service systemd utilisateur rattaché à graphical-session.target
    # (démarrée par UWSM à l'ouverture de la session Hyprland).
    systemd.enable = true;

    # `settings` volontairement laissé vide : si Home Manager générait
    # shell.json, le fichier serait un lien en lecture seule vers le store
    # et l'interface de réglages de Caelestia (Nexus) ne pourrait plus rien
    # enregistrer. À la place, la config de départ ci-dessous est copiée
    # une seule fois (voir home.activation), puis elle t'appartient.
  };

  home.activation.seedCaelestiaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.config/caelestia/shell.json" ]; then
      $DRY_RUN_CMD install -Dm644 ${./caelestia/shell.json} "$HOME/.config/caelestia/shell.json"
    fi
    $DRY_RUN_CMD mkdir -p "$HOME/Pictures/Wallpapers"
  '';
}
