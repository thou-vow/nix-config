{ config, lib, ... }:

{
  options.mods.home.terminal.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf config.mods.home.terminal.yazi.enable {
    programs.yazi.enable = true;
  };
}
