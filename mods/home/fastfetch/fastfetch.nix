{
  config,
  lib,
  ...
}: {
  options.mods.fastfetch.enable = lib.mkEnableOption "fastfetch";

  config = lib.mkIf config.mods.fastfetch.enable {
    programs.fastfetch.enable = true;
  };
}
