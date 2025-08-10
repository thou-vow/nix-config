{
  config,
  lib,
  ...
}: {
  options.mods.television.enable = lib.mkEnableOption "Enable television.";

  config = lib.mkIf config.mods.television.enable {
    programs.television = {
      enable = true;
    };
  };
}
