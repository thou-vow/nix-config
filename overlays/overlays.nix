{inputs, ...}: [
  (final: prev: {
    edge = inputs.nixpkgs-edge.legacyPackages.${final.system};
    stable = inputs.nixpkgs-stable.legacyPackages.${final.system};
  })

  (final: prev: {
    inputs = {
      dwm = inputs.suckless.packages.${final.system}.dwm;
      helix = inputs.helix.packages.${final.system}.default;
      st = inputs.suckless.packages.${final.system}.st;
    };
  })

  (final: prev: {
    custom = {
    };
  })
]
