{
  config,
  inputs,
  ...
}: {
  specialisation.attuned.configuration = {
    nixpkgs.overlays =
      inputs.self.nixosConfigurations."u".config.specialisation.attuned.configuration.nixpkgs.overlays
      ++ [
      ];
  };
}
