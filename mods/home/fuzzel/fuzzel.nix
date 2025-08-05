{
  config,
  lib,
  ...
}: {
  options.mods.fuzzel.enable = lib.mkEnableOption "Enable fuzzel.";

  config = lib.mkIf config.mods.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          include = "${config.mods.flakePath}/mods/home/fuzzel/fuzzel.ini";
        };
      };
    };
  };
}
