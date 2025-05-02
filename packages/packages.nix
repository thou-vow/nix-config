{pkgs, ...}: {
  graalvm-oracle_21 = let
    src = {
      "x86_64-linux" = pkgs.fetchurl {
        # To get the hash, run the following (in bash):
        # nix hash convert --hash-algo sha256 --to sri $(curl -s <replace with url>.sha256)
        hash = "sha256-Z6yFh2tEAs4lO7zoXevRrFFcZQUw7w7Stkx9dUB46CE=";
        url = "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.7_linux-x64_bin.tar.gz";
      };
    };
  in
    pkgs.graalvmPackages.graalvm-oracle.overrideAttrs (oldAttrs: {
      version = "21";
      src = src.${pkgs.system};
    });
  st = pkgs.st.overrideAttrs (oldAttrs: {
    version = "custom";

    src = pkgs.fetchFromGitHub {
      owner = "sergei-grechanik";
      repo = "st-graphics";
      rev = "2d7148e56e9920efc98aef1e714dbf0572486b99";
      hash = "sha256-oHU2LSc3qg502IBcsqbhHgplVLW/KT04ZVKdhDB5moM=";
    };

    patches = [
      (pkgs.fetchpatch {
        # Alpha
        url = "https://github.com/sergei-grechanik/st-graphics/commit/5cfb80edcf8b15449cab08106f1ff14d03b02c48.diff";
        hash = "sha256-E/Kn81gsaBE7jCsru3hr5PwG/WiU+jtBe0Q3Q1o3uFE=";
      })
      (pkgs.fetchpatch {
        # Boxdraw
        url = "https://github.com/sergei-grechanik/st-graphics/commit/1d7c0db479e4c2173e0082060b671068a68cf9cb.diff";
        hash = "sha256-UThsGaJwZKXUAjjvctvji1cQDGq/dPhUCwfLL5TNUAQ=";
      })
      (pkgs.fetchpatch {
        # Xresources with reload signal
        url = "https://st.suckless.org/patches/xresources-with-reload-signal/st-xresources-signal-reloading-20220407-ef05519.diff";
        hash = "sha256-og6cJaMfn7zHfQ0xt6NKhuDNY5VK2CjzqJDJYsT5lrk=";
      })
    ];

    buildInputs =
      oldAttrs.buildInputs
      ++ (with pkgs; [
        imlib2
        zlib
      ]);
  });
}
