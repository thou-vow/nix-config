{ config, lib, ... }:

{
  options.mods.home.terminal.fastfetch.enable = lib.mkEnableOption "fastfetch";

  config = lib.mkIf config.mods.home.terminal.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
    };
  };

}
