{
  config,
  inputs,
  lib,
  options,
  ...
}: {
  imports = [
    ./fastfetch/fastfetch.nix
    ./fish/fish.nix
    ./flatpak.nix
    ./fuzzel/fuzzel.nix
    ./helix/helix.nix
    ./kitty/kitty.nix
    ./nh.nix
    ./niri/niri.nix
    ./prismlauncher.nix
    ./waybar/waybar.nix
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
