{
  config,
  ...
}: {
  mods = {
    brave.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    flatpak.enable = true;
    helix.enable = true;
    hyprland.enable = true;
    kitty.enable = true;
    nh.enable = true;
    prismlauncher.enable = true;
    yazi.enable = true;
  };

  home.persistence = {
    "/nix/persist/plain/home/${config.home.username}" = {
      directories = [
        ".config/BraveSoftware"
        ".local/share/flatpak"
        ".local/share/zoxide"
        ".steam"
        ".var"
      ];
    };
    "/nix/persist/zstd3/home/${config.home.username}" = {
      directories = [
        ".local/share/PrismLauncher"
      ];
    };
  };
}
