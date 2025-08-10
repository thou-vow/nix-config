inputs: final: prev: {
  cemu = inputs.nixpkgs.legacyPackages.${final.system}.cemu.overrideAttrs (prevAttrs: {
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

  niri_git = prev.niri_git.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + " -C target-cpu=skylake -C opt-level=3 -C lto=fat";
      };
  });
}
