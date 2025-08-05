{
  config,
  lib,
  ...
}: {
  options.mods.waybar.enable = lib.mkEnableOption "Enable Waybar.";

  config = lib.mkIf config.mods.waybar.enable {
    programs.waybar.enable = true;
  };
}
