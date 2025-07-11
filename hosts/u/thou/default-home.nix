{
  config,
  inputs,
  lib,
  ...
}: {
  config = lib.mkIf (config.specialisation != {}) {
    nixpkgs.overlays = inputs.self.nixosConfigurations."u".config.nixpkgs.overlays;
  };
}
