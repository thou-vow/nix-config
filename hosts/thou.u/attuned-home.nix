{
  inputs,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    mods = {
      helix.package = inputs.nix-packages.legacyPackages.${pkgs.system}.attunedPackages.helix-steel;
      niri = {
        package = inputs.nix-packages.legacyPackages.${pkgs.system}.attunedPackages.niri-stable;
        xwayland-satellite.package = inputs.nix-packages.legacyPackages.${pkgs.system}.attunedPackages.xwayland-satellite-stable;
      };
    };

    nixpkgs.overlays = [
      (final: prev: {
        nixd = inputs.nix-packages.legacyPackages.${pkgs.system}.attunedPackages.nixd;
        rust-analyzer-unwrapped = inputs.nix-packages.legacyPackages.${pkgs.system}.attunedPackages.rust-analyzer-unwrapped;
      })
    ];

    programs.helix.languages.language-server.rust-analyzer.config = {
      cachePriming.enable = false;
      diagnostics.experimental.enable = true;
      lru.capacity = 32;
      numThreads = 1;
    };

    xdg.dataFile."home-manager/specialisation".text = "attuned";
  };
}
