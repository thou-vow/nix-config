inputs: final: prev: {
  helix_mod = prev.helix_mod.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + " -C target-cpu=skylake -C opt-level=3 -C lto=fat";
      };
  });

  niri_git = prev.niri_git.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + " -C target-cpu=skylake -C opt-level=3 -C lto=fat";
      };
  });

  xwayland-satellite = prev.xwayland-satellite.overrideAttrs (prevAttrs: {
    env =
      prevAttrs.env or {}
      // {
        RUSTFLAGS =
          prevAttrs.env.RUSTFLAGS or ""
          + " -C target-cpu=skylake -C opt-level=3";
      };
  });
}
