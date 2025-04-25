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
      graalvm-oracle_21 = let
        src = {
          "x86_64-linux" = prev.fetchurl {
            # To get the hash, run the following (in bash):
            # nix hash convert --hash-algo sha256 --to sri $(curl -s <replace with url>.sha256)
            hash = "sha256-Z6yFh2tEAs4lO7zoXevRrFFcZQUw7w7Stkx9dUB46CE=";
            url = "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.7_linux-x64_bin.tar.gz";
          };
        };
      in
        prev.graalvmPackages.graalvm-oracle.overrideAttrs (oldAttrs: {
          version = "21";
          src = src.${final.system};
        });
    };
  })
]
