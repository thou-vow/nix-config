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
    flakePath = "/self";
    atuin.enable = true;
    brave.enable = true;
    direnv.enable = true;
    dunst.enable = true;
    fastfetch.enable = true;
    fish = {
      enable = true;
      extraInteractiveShellInitFile = "${config.mods.flakePath}/hosts/thou.u/fish-interactive.fish";
    };
    flatpak.enable = true;
    fuzzel.enable = true;
    helix = {
      enable = true;
      extraInitFile = "${config.mods.flakePath}/hosts/thou.u/helix-init.scm";
    };
    kitty.enable = true;
    niri.enable = true;
    prismlauncher = {
      enable = true;
      jdks = [
        inputs.nix-packages.legacyPackages.${pkgs.system}.graalvm-oracle_21
        pkgs.graalvm-oracle
        pkgs.temurin-bin-8
      ];
    };
    starship.enable = true;
    waybar.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
  };

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
    file.".aider.conf.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/hosts/thou.u/.aider.conf.yml";

    username = "thou";
    homeDirectory = "/home/${config.home.username}";

    packages =
      (with pkgs; [
        aider-chat
        bc
        cemu
        discord
        distrobox
        dolphin-emu
        gcc
        imagemagick
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
      ])
      ++ [
        inputs.nix-packages.legacyPackages.${pkgs.system}.discord-rpc-lsp
      ];

    persistence.${"/persist" + config.home.homeDirectory} = {
      defaultDirectoryMethod = "symlink";
      directories = [
        ".cache/mesa_shader_cache"
        ".cache/nix"
        ".cargo"
        ".config/Cemu"
        ".config/discord"
        ".config/lsfg-vk"
        ".local/share/Cemu"
        ".local/share/containers"
        ".local/share/direnv"
        ".local/share/dolphin-emu"
        ".local/share/nix"
        ".local/share/Steam"
        ".local/share/waydroid"
        ".m2"
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
      files = [
        ".env"
      ];
      allowOther = true;
    };

    sessionVariables = {
      PERSIST_HOME = "$PERSIST" + "$HOME";

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
