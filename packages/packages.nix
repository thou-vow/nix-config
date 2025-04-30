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
      rev = "e5b4ef7160cd2810786d86afbacc857e9363ab6b";
      hash = "sha256-bSaKvWBCiUAwTBq4ZUMRv/eYB+JSsVqJ7tpUPI9pcvQ=";
    };

    patches = [
      (pkgs.fetchpatch {
        url = "https://st.suckless.org/patches/xresources-with-reload-signal/st-xresources-signal-reloading-20220407-ef05519.diff";
        hash = "sha256-og6cJaMfn7zHfQ0xt6NKhuDNY5VK2CjzqJDJYsT5lrk=";
      })
    ];

    buildInputs =
      oldAttrs.buildInputs
      ++ (with pkgs; [
        harfbuzz
        imlib2
        zlib
      ]);
  });
}
