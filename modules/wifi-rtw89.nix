{ pkgs, ... }:

{
  networking.wireless.iwd.settings = {
    General = {
      EnableNetworkConfiguration = false;
      Country = "FR";
    };

    Scan.DisableRoamingScan = true;

    Rank.BandModifier6GHz = 0.5;
  };

  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=FR
    options rtw89_core disable_ps_mode=Y
    options rtw89_pci disable_aspm_l1=Y disable_aspm_l1ss=Y disable_clkreq=Y
  '';

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{class}=="0x028000", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="e0", ATTR{power/control}="on"
  '';

  system.activationScripts.wifiRtw89 = {
    text = ''
      ${pkgs.iw}/bin/iw reg set FR 2>/dev/null || true
      for dev in /sys/class/net/wl*; do
        [ -e "$dev" ] || continue
        ${pkgs.iw}/bin/iw dev "$(${pkgs.coreutils}/bin/basename "$dev")" set power_save off 2>/dev/null || true
      done
      f=/sys/module/rtw89_core/parameters/disable_ps_mode
      [ -w "$f" ] && echo Y > "$f" || true
      for param in disable_aspm_l1 disable_aspm_l1ss disable_clkreq; do
        f="/sys/module/rtw89_pci/parameters/$param"
        [ -w "$f" ] && echo Y > "$f" || true
      done
    '';
  };

  environment.systemPackages = with pkgs; [
    iw
    pciutils
    usbutils
  ];
}
