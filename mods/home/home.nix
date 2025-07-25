{
  config,
  inputs,
  lib,
  options,
  ...
}: {
  imports = [
    ./brave.nix
    ./fastfetch/fastfetch.nix
    ./fish/fish.nix
    ./flatpak.nix
    ./helix/helix.nix
    ./hyprland/hyprland.nix
    ./kitty/kitty.nix
    ./nh.nix
    ./prismlauncher.nix
    ./yazi/yazi.nix
  ];

  options.mods = {
    flakePath = lib.mkOption {
      type = lib.types.str;
      default = lib.mkError "Option 'mods.flakePath' must be explicitly set.";
      description = "The absolute path of this flake. Must be explicitly set.";
    };
  };
}
