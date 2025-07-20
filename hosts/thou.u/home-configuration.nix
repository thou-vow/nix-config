{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
    ./modes/modes.nix
    ../../mods/home/home.nix
  ];

  mods = {
    flakePath = "/flake";
    brave.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    flatpak.enable = true;
    helix.enable = true;
    hyprland.enable = true;
    kitty.enable = true;
    prismlauncher.enable = true;
    yazi.enable = true;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["VictorMono Nerd Font Mono"];
      # sansSerif = ["Noto Sans"];
      # serif = ["Noto Serif"];
      # emoji = ["Noto Color Emoji"];
    };
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
          ".local/share/flatpak"
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
          ".local/share/nix"
          ".local/share/PrismLauncher"
          "Desktop"
          "Projects"
        ];
        allowOther = true;
      };
    };
    sessionVariables = {
      BROWSER = lib.getExe pkgs.brave;
      EDITOR = lib.getExe pkgs.helix;
      SHELL = lib.getExe pkgs.fish;
      VISUAL = lib.getExe pkgs.helix;
    };
    stateVersion = "25.05";
  };

  programs = {
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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
}
