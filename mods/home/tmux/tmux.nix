{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf config.mods.home.tmux.enable {
    home = {
      packages = with pkgs; [tmux];
      sessionVariables = {
        TMUX_SCROLLBACK_PATH = "/tmp/tmux-scrollback.txt";
      };
    };

    xdg.configFile."tmux/tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/mods/home/tmux/tmux.conf";
  };
}
