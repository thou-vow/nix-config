{
  config,
  lib,
  ...
}: {
  options.mods.dunst.enable = lib.mkEnableOption "dunst";

  config = lib.mkIf config.mods.dunst.enable {
    services.dunst = {
      enable = true;
    };
  };
}
