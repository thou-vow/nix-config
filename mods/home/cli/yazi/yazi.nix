{
  config,
  lib,
  ...
}: {
  options.mods.home.cli.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf config.mods.home.cli.yazi.enable {
    programs.yazi.enable = true;
  };
}
