{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  # La CLI appelle ffmpeg/ffprobe (1ère image des wallpapers animés/vidéos,
  # vignettes, extraction des couleurs) — absents du paquet nixpkgs.
  caelestiaCli = pkgs.symlinkJoin {
    name = "caelestia-cli-with-ffmpeg";
    paths = [ pkgs.caelestia-cli ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/caelestia \
        --prefix PATH : ${lib.makeBinPath [ pkgs.ffmpeg ]}
    '';
  };
in
{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.caelestia = {
    enable = true;

    package = inputs.caelestia-shell.packages.${pkgs.system}.default.override {
      withCli = true;
      caelestia-cli = caelestiaCli;
      extraRuntimeDeps = [ pkgs.ffmpeg ];
    };
    cli.package = caelestiaCli;
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
