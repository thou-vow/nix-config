{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.brave = {
    enable = lib.mkEnableOption "Enable Brave.";
  };

  config = lib.mkIf config.mods.brave.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
