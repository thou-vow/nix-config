{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf config.mods.yazi.enable {
    home.packages = with pkgs; [
      yazi
    ];
  };
}
