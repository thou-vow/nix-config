{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf config.mods.tmux.enable {
    home = {
      packages = with pkgs; [tmux];
      sessionVariables = {
        TMUX_SCROLLBACK_PATH = "/tmp/tmux-scrollback.txt";
      };
    };

    xdg.configFile."tmux/tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/tmux/tmux.conf";
  };
}
