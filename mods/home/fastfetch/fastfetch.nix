{
  config,
  lib,
  ...
}: {
  options.mods.home.fastfetch.enable = lib.mkEnableOption "fastfetch";

  config = lib.mkIf config.mods.home.fastfetch.enable {
    programs.fastfetch.enable = true;
  };
}
