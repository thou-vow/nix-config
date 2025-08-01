{
  inputs,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    mods = {
      niri = {
        package = inputs.niri.packages.${pkgs.system}.niri-unstable.overrideAttrs (prevAttrs: {
          # cargoBuildFlags = prevAttrs.cargoBuildFlags or [] ++ ["-v"];

          RUSTFLAGS =
            prevAttrs.RUSTFLAGS
            ++ [
              "-C target-cpu=skylake"
              "-C opt-level=3"
              "-C lto=fat"
            ];
        });
      };
    };

    nixpkgs.overlays =
      inputs.self.nixosConfigurations."u".config.specialisation.attuned.configuration.nixpkgs.overlays
      ++ [
      ];

    xdg.dataFile."home-manager/specialisation".text = "attuned";
  };
}
