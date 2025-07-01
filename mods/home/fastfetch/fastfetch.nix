{
  config,
  lib,
  ...
}: {
  options.mods.fastfetch.enable = lib.mkEnableOption "Enable Fastfetch.";

  config = lib.mkIf config.mods.fastfetch.enable {
    programs.fastfetch.enable = true;
  };
}
