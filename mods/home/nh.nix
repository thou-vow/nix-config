{
  config,
  lib,
  ...
}: {
  options.mods.nh.enable = lib.mkEnableOption "Enable nh.";

  config = lib.mkIf config.mods.nh.enable {
    programs.nh.enable = true;

    home.sessionVariables = {
      NH_HOME_FLAKE = "path:${config.mods.flakePath}";
    };
  };
}
