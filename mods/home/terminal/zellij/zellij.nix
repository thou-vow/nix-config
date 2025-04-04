{
  config,
  lib,
  ...
}:

{
  options.mods.home.terminal.zellij.enable = lib.mkEnableOption "zellij";

  config = lib.mkIf config.mods.home.terminal.zellij.enable {
    programs.zellij.enable = true;

    xdg.configFile = {
      "zellij/config.kdl".source = ./config.kdl;
      "zellij/layouts".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/mods/home/terminal/zellij/layouts";
    };
  };
}
