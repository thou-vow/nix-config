{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.dunst.enable = lib.mkEnableOption "Enable dunst.";

  config = lib.mkIf config.mods.dunst.enable {
    services.dunst = {
      enable = true;
    };
  };
}
