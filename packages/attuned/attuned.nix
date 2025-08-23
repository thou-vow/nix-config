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

  linux-llvm = prev.linux-llvm.override {
    linux = final.linux_cachyos-lto;
    llvmPackages = final.llvmPackages_latest;
    suffix = "attuned";
    useO3 = true;
    mArch = "skylake";
    prependStructuredConfig =
      (import ./kernel-localyesconfig.nix final.lib)
      // (with final.lib.kernel; {
        # Unnecessary stuff not caught by localyesconfig
        "DRM_XE" = no;
        "KVM_AMD" = no;

        # For containers
        "VETH" = yes;

        # Good for gaming
        "NTSYNC" = yes;
      });
    withLTO = "full";
    disableDebug = true;
    features = {
      efiBootStub = true;
      ia32Emulation = true;
      netfilterRPFilter = true;
    };
  };

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
