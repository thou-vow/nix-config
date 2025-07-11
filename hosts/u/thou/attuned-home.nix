{
  config,
  inputs,
  ...
}: {
  specialisation.attuned.configuration = {
    nixpkgs.overlays =
      inputs.self.nixosConfigurations."u".config.specialisation.attuned.configuration.nixpkgs.overlays
      ++ [
        (final: prev: {
          # graalvm-oracle = attunedPkgs.graalvm-oracle;
          # graalvm-oracle_21 = attunedPkgs.graalvm-oracle_21;
          # hyprland = attunedPkgs.hyprland;
          # kitty = attunedPkgs.kitty;
        })
      ];
  };
}
