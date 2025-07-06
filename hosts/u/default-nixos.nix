{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.specialisation != {}) {
    _module.args.pkgs = inputs.nixpkgs.lib.mkForce (import inputs.nixpkgs {
      config.allowUnfree = true;
      localSystem.system = "x86_64-linux";
      overlays = inputs.self.overlays ++ config.nixpkgs.overlays;
    });

    boot.initrd.availableKernelModules = ["ehci_pci"];

    hardware = {
      enableAllFirmware = true;
      enableAllHardware = true;
    };
  };
}
