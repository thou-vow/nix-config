{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.yazi.enable = lib.mkEnableOption "Enable Yazi.";

  config = lib.mkIf config.mods.yazi.enable {
    home.packages = with pkgs; [
      yazi
    ];
  };
}
