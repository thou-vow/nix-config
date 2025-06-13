{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.cli.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf config.mods.home.cli.yazi.enable {
    home.packages = with pkgs; [
      yazi
    ];
  };
}
