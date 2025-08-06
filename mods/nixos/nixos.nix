{
  config,
  inputs,
  lib,
  options,
  ...
}: {
  imports = [
    ./nh.nix
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
        description = "The platform for which NixOS should be built.";
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
