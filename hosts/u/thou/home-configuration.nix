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

  fonts.fontconfig.enable = true;

  home = {
    username = "thou";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      gcc
      libqalculate # Calculator
      nerd-fonts.victor-mono
      steam
      typst
      typstyle
      unimatrix # Simulate display from matrix
      vesktop
    ];
    sessionVariables = {
      BROWSER = "${lib.getExe pkgs.brave}";
      EDITOR = "${lib.getExe pkgs.inputs.helix}";
      VISUAL = "${lib.getExe pkgs.inputs.helix}";
    };
    stateVersion = "25.05";
  };

  programs = {
    alacritty.enable = true;
    brave.enable = true;
    helix = {
      languages.language-server.nixd.config.nixd.options = {
        "nixos".expr = ''(builtins.getFlake "${inputs.self}").nixosConfigurations."u".options'';
        "home-manager".expr = ''(builtins.getFlake "${inputs.self}").homeConfigurations."u@thou".options'';
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

  systemd.user.startServices = "sd-switch";
}
