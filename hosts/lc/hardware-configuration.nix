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
    initrd.availableKernelModules = ["ehci_pci" "ahci" "usb_storage" "ubshid" "sd_mod" "sr_mod" "sdhci_pci"];
    kernelModules = ["kvm-intel"];
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  swapDevices = [{device = "/dev/disk/by-uuid/ade4bc93-b14f-4e27-b680-e2d576971cd8";}];
}
