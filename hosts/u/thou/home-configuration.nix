{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
    ../../../mods/home/home.nix
  ];

  mods = {
    flakePath = "/home/thou/nix-in-a-vat";
    brave.enable = true;
    fastfetch.enable = true;
    helix.enable = true;
    hyprland.enable = true;
    kitty.enable = true;
    nushell.enable = true;
    yazi.enable = true;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["VictorMono Nerd Font Mono"];
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
      lutris
      nerd-fonts.victor-mono
      qbittorrent
      steam
      python3
      typst
      typstyle
      unimatrix
    ];
    persistence = {
      "/nix/persist/plain/home/${config.home.username}" = {
        defaultDirectoryMethod = "symlink";
        directories = [
          ".config/BraveSoftware"
          ".ssh"
          ".steam"
          ".var"
          "Documents"
          "Downloads"
          "Games"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"
        ];
        allowOther = true;
      };
      "/nix/persist/zstd3/home/${config.home.username}" = {
        defaultDirectoryMethod = "symlink";
        directories = [
          "nix-in-a-vat"
          "Projects"
        ];
        allowOther = true;
      };
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
    kitty.keybindings = {
      "alt+e" = "launch --stdin-source=@screen_scrollback ${lib.getExe pkgs.helix}";
    };
  };
}
