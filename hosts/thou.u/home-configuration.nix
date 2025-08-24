{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./attuned-home.nix
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
      azahar
      cemu
      bc
      distrobox
      equibop
      gcc
      krita
      lsfg-vk
      lsfg-vk-ui
      nerd-fonts.victor-mono
      noto-fonts
      noto-fonts-emoji
      qbittorrent
      python3
      steam
      typst
    ];

    persistence.${"/persist" + config.home.homeDirectory} = {
      defaultDirectoryMethod = "symlink";
      directories = [
        ".cache/mesa_shader_cache"
        ".cache/nix"
        ".config/Cemu"
        ".config/lsfg-vk"
        ".local/share/Cemu"
        ".local/share/nix"
        ".ssh"
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
        ".local/share/containers"
        ".local/share/flatpak"
        ".local/share/PrismLauncher"
        ".local/share/steel"
        ".local/share/zoxide"
        ".steam"
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
    stateVersion = "25.05";
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
    nix-search-tv.enable = true;
  };

  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/hosts/thou.u/niri.kdl";
}
