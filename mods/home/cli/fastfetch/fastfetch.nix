{
  config,
  lib,
  ...
}: {
  options.mods.home.cli.fastfetch.enable = lib.mkEnableOption "fastfetch";

  config = lib.mkIf config.mods.home.cli.fastfetch.enable {
    programs.fastfetch.enable = true;
  };
}
