{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.mods.niri = {
    enable = lib.mkEnableOption "Enable niri.";
    package = lib.mkPackageOption inputs.niri-flake.packages.${pkgs.system} "niri" {default = "niri-stable";};
    xwayland-satellite.package =
      lib.mkPackageOption inputs.niri-flake.packages.${pkgs.system} "xwayland-satellite" {default = "xwayland-satellite-stable";};
  };

  config = lib.mkIf config.mods.niri.enable {
    home.packages =
      (with pkgs; [
        brightnessctl
        dash
        nautilus
        wireplumber
        wl-clipboard
      ])
      ++ [
        config.mods.niri.package
        config.mods.niri.xwayland-satellite.package
      ];

    xdg.portal = {
      enable = true;
      configPackages = [config.mods.niri.package];
      extraPortals = [pkgs.xdg-desktop-portal-gnome];
    };
  };
}
