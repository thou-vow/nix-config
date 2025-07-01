{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.specialisation != {}) {
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    hardware = {
      enableAllFirmware = true;
      enableAllHardware = true;
    };
  };
}
