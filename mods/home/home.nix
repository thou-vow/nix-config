{
  lib,
  ...
}: {
  imports = [
    ./atuin.nix
    ./brave.nix
    ./direnv.nix
    ./dunst/dunst.nix
    ./fastfetch/fastfetch.nix
    ./fish/fish.nix
    ./flatpak.nix
    ./fuzzel/fuzzel.nix
    ./helix/helix.nix
    ./kitty/kitty.nix
    ./niri/niri.nix
    ./prismlauncher.nix
    ./starship.nix
    ./waybar/waybar.nix
    ./yazi/yazi.nix
    ./zoxide.nix
  ];

  options.mods = {
    flakePath = lib.mkOption {
      type = lib.types.str;
      default = lib.mkError "Option 'mods.flakePath' must be explicitly set.";
      description = "The absolute path of this flake. Must be explicitly set.";
    };
  };
}
