{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.specialisation != {}) {
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    };

    hardware = {
      enableAllFirmware = true;
      enableAllHardware = true;
    };
  };
}
