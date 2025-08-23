inputs: final: prev: {
  cemu = prev.cemu.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        CFLAGS = prevAttrs.env.CFLAGS or "" + " -O3 -march=skylake";
        CXXFLAGS = prevAttrs.env.CXXFLAGS or "" + " -O3 -march=skylake";
      };
  });

  helix-steel = prev.helix-steel.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + " -C target-cpu=skylake -C opt-level=3 -C lto=fat";
      };
  });

  linuxPackages_cachyos-lto =
    (prev.linuxPackages_cachyos-lto.cachyOverride {
      useLTO = "thin";
      withoutDebug = true;
    }).extend (final: prev: {
      kernel = prev.kernel.overrideAttrs (prevAttrs: {
        makeFlags =
          prevAttrs.makeFlags
          ++ [
            "KCFLAGS+=-march=skylake"
            "KRUSTFLAGS+=-Ctarget-cpu=skylake"
          ];
      });
    });

  niri-unstable = prev.niri-unstable.overrideAttrs (prevAttrs: {
    RUSTFLAGS =
      prevAttrs.RUSTFLAGS or []
      ++ [
        "-C target-cpu=skylake"
        "-C opt-level=3"
        "-C lto=fat"
      ];
  });

  rust-analyzer-unwrapped = prev.rust-analyzer-unwrapped.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + " -C target-cpu=skylake -C opt-level=3";
      };
  });

  xwayland-satellite-unstable = prev.xwayland-satellite-unstable.overrideAttrs (prevAttrs: {
    RUSTFLAGS =
      prevAttrs.RUSTFLAGS or []
      ++ [
        "-C target-cpu=skylake"
        "-C opt-level=3"
      ];
  });
}
