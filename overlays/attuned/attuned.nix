inputs: final: prev: {
  helix_mod = prev.helix_mod.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + "-C target-cpu=skylake -C opt-level=3 -C lto=fat";
      };
  });

  niri_git = prev.niri_git.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + "-C target-cpu=skylake -C opt-level=3 -C lto=fat";
      };
  });

  linux-llvm = final.linux-llvm.override {
    linux = final.linux_cachyos-lto;
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

  xwayland-satellite = prev.xwayland-satellite.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + "-C target-cpu=skylake -C opt-level=3";
      };
  });
}
