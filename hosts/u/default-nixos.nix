{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # No specialisation configuration
  config = inputs.nixpkgs.lib.mkIf (config.specialisation != {}) {
    boot = {
      initrd.availableKernelModules = [
        "ehci_pci"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "uas"
        "sd_mod"
        "usbhid"
      ];

      kernelPackages = inputs.chaotic.legacyPackages.${pkgs.system}.linuxPackages_cachyos-lto;
    };

    hardware = {
      cpu = {
        amd.updateMicrocode = true;
        intel.updateMicrocode = true;
      };
      enableAllFirmware = true;
      enableAllHardware = true;
    };

    # Sometimes the default don't work
    networking.nameservers = [
      "8.8.4.4"
      "8.8.8.8"
    ];

    services.cloudflare-warp.enable = true;

    swapDevices = [
      {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}
    ];

    # https://github.com/NixOS/nixpkgs/pull/423933
    system.modulesTree = [(lib.getOutput "modules" config.boot.kernelPackages.kernel)];
  };
}
