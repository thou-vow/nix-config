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
        niri_git
        wireplumber
        wl-clipboard
        xwayland-satellite
      ];

    xdg = {
      portal = {
        enable = true;
        configPackages = [
          pkgs.niri_git
        ];
        extraPortals = [
          pkgs.xdg-desktop-portal-gnome
        ];
      };
    };
  };
}
