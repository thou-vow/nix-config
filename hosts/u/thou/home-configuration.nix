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
    brave.enable = true;
    dwm.enable = true;
    fastfetch.enable = true;
    helix.enable = true;
    nushell.enable = true;
    picom.enable = true;
    prismlauncher.enable = true;
    st.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["VictorMono Nerd Font Mono:antialias=true:autohint=true:weight=demibold"];
  };
  
  home = {
    username = "thou";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      azahar
      clock-rs
      bc
      discord
      gcc
      gimp
      graalvm-oracle_21
      kitty
      krita
      nerd-fonts.victor-mono
      lutris
      qbittorrent
      steam
      python3
      typst
      typstyle
      unimatrix
    ];
    sessionVariables = {
      BROWSER = lib.getExe pkgs.brave;
      EDITOR = lib.getExe pkgs.helix;
      EXPLORER = "";
      QUICKAPPS = "";
      PRINTSCREEN = "${lib.getExe pkgs.flameshot} gui";
      TERMINAL = lib.getExe pkgs.st;
      VISUAL = lib.getExe pkgs.helix;
    };
    stateVersion = "25.05";
  };

  programs = {
    bash.enable = true;
    brave.enable = true;
    helix = {
      languages.language-server.nixd.config.nixd.options = {
        nixos.expr = ''(builtins.getFlake "${inputs.self}").nixosConfigurations."u".options'';
        home-manager.expr = ''(builtins.getFlake "${inputs.self}").homeConfigurations."thou@u".options'';
      };
      settings.editor.statusline.mode = {
        normal = "NORMAL";
        insert = "INSERT";
        select = "SELECT";
      };
    };
    home-manager.enable = true;
  };

  services.flameshot.enable = true;
}
