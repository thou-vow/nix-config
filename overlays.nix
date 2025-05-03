{inputs, ...}: [
  (final: prev: {
    edge = inputs.nixpkgs-edge.legacyPackages.${final.system};
    stable = inputs.nixpkgs-stable.legacyPackages.${final.system};
    nix-gaming = inputs.nix-gaming.packages.${final.system};
  })

  (final: prev: {
    inputs = {
      helix = inputs.helix.packages.${final.system}.default;
    };
  })

  (final: prev: {custom = import ./packages/packages.nix {pkgs = final;};})
]
