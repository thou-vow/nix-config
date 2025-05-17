{
  inputs,
  lib,
  pkgs,
  ...
}: let
  # It has no overlays
  attunedPkgs = import inputs.nixpkgs {
    localSystem = {
      gcc.arch = "skylake";
      gcc.tune = "skylake";
      system = pkgs.system;
    };
  };
in {
  # specialisation.attuned.configuration = {
  #   boot = {
  #     loader.grub.configurationName = lib.mkOverride 69 "Attuned";
  #     kernelPackages = lib.mkOverride 69 (attunedPkgs.linuxKernel.packages.linux_xanmod_latest);
  #   };

  #   nixpkgs.overlays = [
  #     (final: prev: {
  #     })
  #   ];
  # };
}
