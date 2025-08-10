{
  config,
  lib,
  ...
}: {
  options.mods.atuin = {
    enable = lib.mkEnableOption "Enable atuin.";
  };

  config = lib.mkIf config.mods.atuin.enable {
    programs.atuin = {
      enable = true;
    };
  };
}


