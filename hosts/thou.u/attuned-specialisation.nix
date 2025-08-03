{
  inputs,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    mods = {
      niri = {
        package = inputs.niri.packages.${pkgs.system}.niri-unstable.overrideAttrs (prevAttrs: {
          RUSTFLAGS =
            prevAttrs.RUSTFLAGS or []
            ++ [
              "-C target-cpu=skylake"
              "-C opt-level=3"
              "-C lto=fat"
            ];
        });
        xwayland-satellite.package = inputs.niri.packages.${pkgs.system}.xwayland-satellite-unstable.overrideAttrs (prevAttrs: {
          RUSTFLAGS =
            prevAttrs.RUSTFLAGS or []
            ++ [
              "-C target-cpu=skylake"
              "-C opt-level=3"
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
