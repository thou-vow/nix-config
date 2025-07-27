{
  inputs,
  ...
}: {
  specialisation.attuned.configuration = {
    nixpkgs.overlays =
      inputs.self.nixosConfigurations."u".config.specialisation.attuned.configuration.nixpkgs.overlays
      ++ [
      ];

    xdg.dataFile."home-manager/specialisation".text = "attuned";
  };
}
