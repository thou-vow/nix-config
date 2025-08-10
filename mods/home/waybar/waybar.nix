{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.waybar.enable = lib.mkEnableOption "Enable Waybar.";

  config = lib.mkIf config.mods.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    # xdg.configFile = {
    #   "waybar/config.jsonc" = {
    #     source =
    #       config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/waybar/config.jsonc";
    #     onChange = ''
    #       ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    #     '';
    #   };
    #   "waybar/style.css" = {
    #     source =
    #       config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/waybar/style.css";
    #     onChange = ''
    #       ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    #     '';
    #   };
    # };
  };
}
