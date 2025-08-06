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

    pkgs = {
      overlays = lib.mkOption {
        type = options.nixpkgs.overlays.type;
        default = [];
        description = "List of overlays to apply to pkgs.";
      };

      system = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "The platform for which Home Manager should be built.";
      };
    };
  };

  config = {
    _module.args.pkgs = inputs.nixpkgs.lib.mkForce (import inputs.nixpkgs {
      config.allowUnfree = true;
      localSystem.system = config.mods.pkgs.system;
      overlays = config.mods.pkgs.overlays;
    });
  };
}
