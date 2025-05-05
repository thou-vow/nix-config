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
      alacritty
      azahar
      bc
      gcc
      gimp
      graalvm-oracle_21
      krita
      lutris
      nerd-fonts.victor-mono
      steam
      typst
      typstyle
      unimatrix
      vesktop
      inputs.nix-gaming.packages.${pkgs.system}.wine-ge
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
        "nixos".expr = ''(builtins.getFlake "${inputs.self}").nixosConfigurations."u".options'';
        "home-manager".expr = ''(builtins.getFlake "${inputs.self}").homeConfigurations."thou@u".options'';
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
