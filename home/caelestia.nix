{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.caelestia = {
    enable = true;

    package = pkgs.caelestia-shell;
    cli.package = pkgs.caelestia-cli;
    cli.enable = true;

    systemd.enable = true;

  };

  home.activation.seedCaelestiaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.config/caelestia/shell.json" ]; then
      $DRY_RUN_CMD install -Dm644 ${./caelestia/shell.json} "$HOME/.config/caelestia/shell.json"
    fi
    $DRY_RUN_CMD mkdir -p "$HOME/Pictures/Wallpapers"
  '';
}
