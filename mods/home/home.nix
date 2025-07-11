{lib, ...}: {
  imports = [
    ./brave.nix
    ./fastfetch/fastfetch.nix
    ./helix/helix.nix
    ./hyprland/hyprland.nix
    ./kitty/kitty.nix
    ./nushell/nushell.nix
    ./prismlauncher.nix
    ./yazi/yazi.nix
  ];

  options.mods = {
    flakePath = lib.mkOption {
      type = lib.types.str;
      default = lib.mkError "Option 'mods.flakePath' must be explicitly set.";
      description = "The absolute path of this flake. Must be explicitly set.";
      example = "/home/thou/nix-in-a-vat";
    };
  };
}
