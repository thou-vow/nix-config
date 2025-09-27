{
  config,
  lib,
  ...
}: {
  options.mods.waybar.enable = lib.mkEnableOption "Enable Waybar.";

  config = lib.mkIf config.mods.waybar.enable {
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        include = ["${config.mods.flakePath}/mods/home/waybar/config.jsonc"] ;
      }; 
      style = # css
      ''
        @import url("file://${config.mods.flakePath}/mods/home/waybar/style.css");
      '';
      systemd.enable = true;
    };
  };
}
