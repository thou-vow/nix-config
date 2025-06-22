{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf config.mods.home.yazi.enable {
    home.packages = with pkgs; [
      yazi
    ];
  };
}
