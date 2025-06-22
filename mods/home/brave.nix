{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.brave.enable = lib.mkEnableOption "brave";

  config = lib.mkIf config.mods.home.brave.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
