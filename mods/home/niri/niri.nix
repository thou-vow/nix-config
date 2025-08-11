{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options.mods.niri = {
    enable = lib.mkEnableOption "Enable niri.";
  };

  config = lib.mkIf config.mods.niri.enable {
    home.packages = with pkgs;
      [
        brightnessctl
        dash
        niri-unstable
        wireplumber
        wl-clipboard
        xwayland-satellite-unstable
      ];

    xdg = {
      portal = {
        enable = true;
        configPackages = [
          pkgs.niri-unstable
        ];
        extraPortals = [
          pkgs.xdg-desktop-portal-gnome
        ];
      };
    };
  };
}
