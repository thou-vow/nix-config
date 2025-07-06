{
  config,
  inputs,
  ...
}: {
  specialisation.attuned.configuration = {
    _module.args.pkgs = inputs.nixpkgs.lib.mkForce (import inputs.nixpkgs {
      config.allowUnfree = true;
      localSystem = {
        # gcc.arch = "skylake";
        # gcc.tune = "skylake";
        system = "x86_64-linux";
      };
      overlays =
        inputs.self.overlays
        ++ inputs.self.nixosConfigurations."u".config.specialisation.attuned.configuration.nixpkgs.overlays
        ++ config.nixpkgs.overlays;
    });
  };
}
