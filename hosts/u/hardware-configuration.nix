{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "uas"
        "sd_mod"
        "rtsx_usb_sdmmc"
        "ehci_pci"
        "usb_storage"
        "usbhid"
        "sr_mod"
        "sdhci_pci"
      ];
    };
    kernelModules = ["kvm-intel"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part2";
      fsType = "ext4";
      options = [
        "commit=60"
        "data=journal"
        "journal_async_commit"
        "noatime"
      ];
    };
    ${config.boot.loader.efi.efiSysMountPoint} = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part1";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  swapDevices = [
    {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}
  ];
}
