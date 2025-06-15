{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.specialisation != {}) {
    hardware = {
      enableAllFirmware = true;
      enableAllHardware = true;
    };
  };
}
