{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.brave.enable = lib.mkEnableOption "brave";

  config = lib.mkIf config.mods.brave.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
