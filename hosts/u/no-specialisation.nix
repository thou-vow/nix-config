{
  config,
  inputs,
  pkgs,
  ...
}: {
  # No specialisation configuration
  config = inputs.nixpkgs.lib.mkIf (config.specialisation != {}) {
    boot.initrd.availableKernelModules = [
      "ehci_pci"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "uas"
      "sd_mod"
      "usbhid"
    ];

    hardware = {
      cpu = {
        amd.updateMicrocode = true;
        intel.updateMicrocode = true;
      };
      enableAllFirmware = true;
      enableAllHardware = true;
    };

    # Sometimes the default nameservers don't work
    networking.nameservers = [
      "8.8.4.4"
      "8.8.8.8"
    ];

    swapDevices = [
      {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}
    ];
  };
}
