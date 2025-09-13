{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./attuned-home.nix
    ./default-home.nix
    inputs.impermanence.homeManagerModules.impermanence
  ];

  mods = {
    flakePath = "/flake";
    atuin.enable = true;
    brave.enable = true;
    dunst.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    flatpak.enable = true;
    fuzzel.enable = true;
    helix.enable = true;
    kitty.enable = true;
    niri.enable = true;
    prismlauncher.enable = true;
    television.enable = true;
    waybar.enable = true;
    yazi.enable = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      nix = final.lixPackageSets.latest.lix;
    })
  ];

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
      bc
      cemu
      distrobox
      dolphin-emu
      equibop
      gcc
      krita
      lsfg-vk
      lsfg-vk-ui
      nerd-fonts.victor-mono
      noto-fonts
      noto-fonts-emoji
      python3
      qbittorrent
      ripgrep
      typst
      xdg-utils
    ];

    persistence.${"/persist" + config.home.homeDirectory} = {
      defaultDirectoryMethod = "symlink";
      directories = [
        ".cache/mesa_shader_cache"
        ".cache/nix"
        ".config/Cemu"
        ".config/lsfg-vk"
        ".local/share/Cemu"
        ".local/share/containers"
        ".local/share/dolphin-emu"
        ".local/share/nix"
        ".local/share/Steam"
        ".ssh"
        ".steam"
        "Desktop"
        "Documents"
        "Downloads"
        "Games"
        "Music"
        "Pictures"
        "Projects"
        "Public"
        "Templates"
        "Videos"

        ".config/BraveSoftware"
        ".local/share/atuin"
        ".local/share/flatpak"
        ".local/share/PrismLauncher"
        ".local/share/steel"
        ".local/share/zoxide"
        ".var"
      ];
      allowOther = true;
    };

    sessionVariables = {
      BROWSER = "brave";
      EDITOR = "hx";
      TERMINAL = "kitty -1";
      VISUAL = "hx";

      LSFG_PROCESS = "3x";
    };
    stateVersion = "25.11";
  };

  programs = {
    git = {
      enable = true;
      userName = "thou-vow";
      userEmail = "thou.vow.etoile@gmail.com";
    };
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
      "alt+e" = "launch --stdin-source=@screen_scrollback hx";
    };
  };

  xdg.configFile = let
    flakePath = config.mods.flakePath;
  in {
    "niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/hosts/thou.u/niri.kdl";
  };
}
