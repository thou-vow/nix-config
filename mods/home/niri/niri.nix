{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options.mods.niri = {
    enable = lib.mkEnableOption "Enable niri.";
    package = lib.mkPackageOption inputs.niri.packages.${pkgs.system} "niri" {
      default = "niri-unstable";
    };
    xwayland-satellite.package = lib.mkPackageOption inputs.niri.packages.${pkgs.system} "xwayland-satellite" {
      default = "xwayland-satellite-unstable";
    };
  };

  config = lib.mkIf config.mods.niri.enable {
    home.packages = with pkgs;
      [
        brightnessctl
        dash
        wireplumber
        wl-clipboard
      ]
      ++ [
        config.mods.niri.package
        config.mods.niri.xwayland-satellite.package
      ];

    xdg = {
      configFile."niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/niri/config.kdl";
      portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gnome];
        configPackages = [
          config.mods.niri.package
        ];
      };
    };
  };
}
