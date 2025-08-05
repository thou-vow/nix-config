{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./attuned-specialisation.nix
    ./no-specialisation.nix
    ./mod-prefs/mod-prefs.nix
  ];

  mods.flakePath = "/flake";

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["VictorMono Nerd Font Mono"];
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
      emoji = ["Noto Color Emoji"];
    };
  };

  home = {
    username = "thou";
    homeDirectory = "/home/${config.home.username}";

    packages = with pkgs; [
      azahar
      brave
      cemu
      clock-rs
      bc
      discord
      gcc
      gimp
      krita
      lutris
      nerd-fonts.victor-mono
      noto-fonts
      noto-fonts-emoji
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
          ".config/Cemu"
          ".local/share/Cemu"
          ".ssh"
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
          "Desktop"
          "Projects"
        ];
        allowOther = true;
      };
    };

    sessionVariables = {
      BROWSER = lib.getExe pkgs.brave;
      EDITOR = lib.getExe pkgs.helix;
      TERMINAL = "${lib.getExe pkgs.kitty} -1";
      VISUAL = lib.getExe pkgs.helix;
    };
    stateVersion = "25.05";
  };

  programs = {
    git = {
      enable = true;
      userName = "thou-vow";
      userEmail = "thou.vow.etoile@gmail.com";
    };
    home-manager.enable = true;
  };
}
