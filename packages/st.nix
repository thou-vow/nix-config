{
  fetchFromGitHub,
  fetchpatch,
  fontconfig,
  freetype,
  harfbuzz,
  imlib2,
  lib,
  libX11,
  libXft,
  ncurses,
  pkg-config,
  stdenv,
  zlib,
  ...
}:
stdenv.mkDerivation {
  pname = "st";
  version = "custom";

  src = fetchFromGitHub {
    owner = "sergei-grechanik";
    repo = "st-graphics";
    rev = "e5b4ef7160cd2810786d86afbacc857e9363ab6b";
    hash = "sha256-bSaKvWBCiUAwTBq4ZUMRv/eYB+JSsVqJ7tpUPI9pcvQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://st.suckless.org/patches/xresources-with-reload-signal/st-xresources-signal-reloading-20220407-ef05519.diff";
      hash = "sha256-og6cJaMfn7zHfQ0xt6NKhuDNY5VK2CjzqJDJYsT5lrk=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];
  buildInputs = [
    harfbuzz
    libX11
    libXft
    imlib2
    zlib
  ];

  makeFlags = ["PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"];

  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  installFlags = ["PREFIX=${placeholder "out"}"];

  outputs = ["out" "terminfo"];

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal from Suckless.org";
    license = lib.licenses.mit;
    maintainers = [];
    platforms = lib.platforms.unix;
    mainProgram = "st";
  };
}


