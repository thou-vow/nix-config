{
  inputs,
  ...
}: {
  specialisation.attuned.configuration = {
    nixpkgs.overlays =
      inputs.self.nixosConfigurations."u".config.specialisation.attuned.configuration.nixpkgs.overlays
      ++ [
        (final: prev: {
          niri_git = prev.niri_git.overrideAttrs (prevAttrs: {
            env =
              prevAttrs.env
              // {
                RUSTFLAGS =
                  prevAttrs.env.RUSTFLAGS
                  + "-C target-cpu=skylake -C opt-level=3 -C lto=fat";
              };
          });

          xwayland-satellite = prev.xwayland-satellite.overrideAttrs (prevAttrs: {
            env =
              prevAttrs.env or {}
              // {
                RUSTFLAGS =
                  prevAttrs.env.RUSTFLAGS or ""
                + "-C target-cpu=skylake -C opt-level=3";
              };
          });
        })
      ];

    xdg.dataFile."home-manager/specialisation".text = "attuned";
  };
}
