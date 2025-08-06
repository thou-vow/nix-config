{
  config,
  lib,
  ...
}: {
  options.mods.nh.enable = lib.mkEnableOption "Enable nh.";

  config = lib.mkIf config.mods.nh.enable {
    programs.nh.enable = true;

    environment.variables = {
      NH_FLAKE = "path:${config.mods.flakePath}";
    };
  };
}
