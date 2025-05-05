{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../../mods/home/home.nix
  ];

  mods.home = {
    gui = {
      prismlauncher.enable = true;
      st.enable = true;
    };
    cli = {
      fastfetch.enable = true;
      helix.enable = true;
      nushell.enable = true;
      tmux.enable = true;
      yazi.enable = true;
    };
  };

  home = {
    username = "thou";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      bc
      gcc
      nerd-fonts.victor-mono
      steam
      unimatrix
      vesktop
    ];
    sessionVariables = {
      BROWSER = lib.getExe pkgs.brave;
      EDITOR = lib.getExe pkgs.helix;
      VISUAL = lib.getExe pkgs.helix;
    };
    stateVersion = "25.05";
  };

  programs = {
    bash.enable = true;
    brave.enable = true;
    helix = {
      languages.language-server.nixd.config.nixd.options = {
        "nixos".expr = ''(builtins.getFlake "${inputs.self}").nixosConfigurations."cendrillon".options'';
        "home-manager".expr = ''(builtins.getFlake "${inputs.self}").homeConfigurations."thou@cendrillon".options'';
      };
      settings.editor.statusline = {
        mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
      };
    };
    home-manager.enable = true;
  };
}
