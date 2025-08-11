inputs: final: prev: {
  cemu = prev.cemu.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        CFLAGS = prevAttrs.env.CFLAGS or "" + " -O3 -march=skylake";
        CXXFLAGS = prevAttrs.env.CXXFLAGS or "" + " -O3 -march=skylake";
      };
  });

  helix_mod = prev.helix_mod.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + " -C target-cpu=skylake -C opt-level=3 -C lto=fat";
      };
  });

  linux-llvm = prev.linux-llvm.override {
    linux = prev.linux_cachyos-lto;
    suffix = "attuned";
    useO3 = true;
    mArch = "skylake";
    prependStructuredConfig = import ./kernel-localyesconfig.nix final.lib;
    withLTO = "full";
    disableDebug = true;
    features = {
      efiBootStub = true;
      ia32Emulation = true;
      netfilterRPFilter = true;
    };
  };

  lixPackageSets.latest.lix = prev.lixPackageSets.latest.lix.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        CFLAGS = prevAttrs.env.CFLAGS or "" + " -O3 -march=skylake";
        CXXFLAGS = prevAttrs.env.CXXFLAGS or "" + " -O3 -march=skylake";
      };
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

  xwayland-satellite-unstable = prev.xwayland-satellite-unstable.overrideAttrs (prevAttrs: {
    RUSTFLAGS =
      prevAttrs.RUSTFLAGS or []
      ++ [
        "-C target-cpu=skylake"
        "-C opt-level=3"
      ];
  });
}
