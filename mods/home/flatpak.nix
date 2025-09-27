{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.flatpak.enable = lib.mkEnableOption "Enable Flatpak.";

  config = lib.mkIf config.mods.flatpak.enable {
    home.packages = with pkgs; [
      flatpak
    ];
  };
}
