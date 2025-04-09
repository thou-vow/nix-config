{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mods.home.terminal.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf config.mods.home.terminal.tmux.enable {
    # Installing it just as a package because it's home-manager configuration is unnecessary
    home = {
      packages = with pkgs; [ tmux ];
      sessionVariables."TMUX_EDIT_SCROLLBACK_PATH" = "/tmp/tmux-scrollback.txt";
    };

    programs.nushell.enable = true;

    xdg.configFile."tmux/tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/mods/home/terminal/tmux/tmux.conf";
  };
}
