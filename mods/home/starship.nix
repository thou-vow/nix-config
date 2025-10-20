{
  config,
  lib,
  ...
}: {
  options.mods.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf config.mods.starship.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
    };
  };
}
