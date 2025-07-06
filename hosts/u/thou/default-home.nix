{
  config,
  inputs,
  lib,
  ...
}: {
  config = lib.mkIf (config.specialisation != {}) {
    _module.args.pkgs = inputs.nixpkgs.lib.mkForce (import inputs.nixpkgs {
      config.allowUnfree = true;
      localSystem.system = "x86_64-linux";
      overlays =
        inputs.self.overlays
        ++ inputs.self.nixosConfigurations."u".config.nixpkgs.overlays
        ++ config.nixpkgs.overlays;
    });
  };
}
