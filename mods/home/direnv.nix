{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf config.mods.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
