{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.brave.enable = lib.mkEnableOption "Brave";

  config = lib.mkIf config.mods.brave.enable {
    programs.brave = {
      enable = true;
    };
  };
}
