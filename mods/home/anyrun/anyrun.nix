{
  config,
  lib,
  ...
}: {
  options.mods.anyrun = {
    enable = lib.mkEnableOption "Enable anyrun.";
  };

  config = lib.mkIf config.mods.anyrun.enable {
    programs.anyrun = {
      enable = true;
    };
  };
}

