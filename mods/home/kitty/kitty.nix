{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options.mods.kitty = {
    enable = lib.mkEnableOption "Enable Kitty.";
  };

  config = lib.mkIf config.mods.kitty.enable {
    programs.kitty = {
      enable = true;
      extraConfig = ''
        include ${config.mods.flakePath}/mods/home/kitty/kitty.conf
      '';
      settings.clear_all_shortcuts = "yes";
    };
  };
}
