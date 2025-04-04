{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ../../../mods/home/home.nix
    inputs.stylix.homeManagerModules.stylix
  ];

  mods.home = {
    terminal = {
      fastfetch.enable = true;
      helix.enable = true;
      nushell.enable = true;
      yazi.enable = true;
      zellij.enable = true;
    };
  };

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = {
      base00 = "#19171c";
      base01 = "#26232a";
      base02 = "#585260";
      base03 = "#655f6d";
      base04 = "#7e7887";
      base05 = "#8b8792";
      base06 = "#e2dfe7";
      base07 = "#efecf4";
      base08 = "#be4678";
      base09 = "#aa573c";
      base0A = "#a06e3b";
      base0B = "#2a9292";
      base0C = "#398bc6";
      base0D = "#576ddb";
      base0E = "#955ae7";
      base0F = "#bf40bf";
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.victor-mono;
        name = "VictorMono Nerd Font Mono";
      };
      sizes.terminal = 8.5;
    };
    image = "${config.home.homeDirectory}/Pictures/b65e01cf631c5a71dec76941b071e6ac.jpg";
    targets = {
      alacritty.enable = true;
      btop.enable = true;
      helix.enable = true;
      yazi.enable = true;
      zellij.enable = true;
    };
  };

  home = {
    username = "thou";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      discord
      gcc
      libqalculate # Calculator
      unimatrix # Simulate display from matrix
    ];
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
