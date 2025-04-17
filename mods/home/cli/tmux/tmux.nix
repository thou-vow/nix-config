{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.cli.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf config.mods.home.cli.tmux.enable {
    # Installing it just as a package because it's home-manager configuration is unnecessary
    home = {
      packages = with pkgs; [tmux];
      sessionVariables = {
        TMUX_SCROLLBACK_PATH = "/tmp/tmux-scrollback.txt";
      };
    };

    xdg.configFile."tmux/tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/mods/home/cli/tmux/tmux.conf";
  };
}
