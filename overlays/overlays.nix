{inputs, ...}: [
  (final: prev: {
    edge = inputs.nixpkgs-edge.legacyPackages.${final.system};
    stable = inputs.nixpkgs-stable.legacyPackages.${final.system};
  })

  (final: prev: {
    inputs = {
      helix = inputs.helix.packages.${final.system}.default;
    };
  })

  (final: prev: {
    custom = {
      st = prev.st.overrideAttrs (oldAttrs: {
        buildInputs =
          oldAttrs.buildInputs
          ++ (with final; [
            imlib2
            zlib
          ]);

        patches = [
          (prev.fetchurl {
            url = "https://st.suckless.org/patches/kitty-graphics-protocol/st-kitty-graphics-20240922-a0274bc.diff";
            sha256 = "1vj5jrg2b0zf6868w2nmm1vjdpk4dsz3lwmr9q23wfaj8jc3c3l6";
          })
          (prev.fetchurl {
            url = "https://st.suckless.org/patches/xresources-with-reload-signal/st-xresources-signal-reloading-20220407-ef05519.diff";
            sha256 = "1hjb1ssv53cv2lz4p9fbd0xpwvq9f3mdd7l16gxb2kdiyyi4gr49";
          })
        ];
      });
    };
  })
]
