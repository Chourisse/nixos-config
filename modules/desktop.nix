{ ... }:

{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = "chouris";
      };
    };
    desktopManager.plasma6.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Requis pour PipeWire
  security.rtkit.enable = true;
}
