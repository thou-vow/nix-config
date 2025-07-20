{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.specialisation != {}) {
    nixpkgs.overlays = [
      (final: prev: {
        hm-activate = final.writeShellScript "hm-activate" ''
          #!${lib.getExe final.dash}

          for gen in $(
            ${final.nix}/bin/nix-store -q --referrers \
              $(
                ${lib.getExe final.home-manager} generations | \
                ${final.toybox}/bin/head -1 | \
                ${final.toybox}/bin/cut -d ' ' -f7
              )
          ); do if [ -d "$gen/specialisation" ]; then
              "$gen/activate"
            fi
          done
        '';

        nix = final.lixPackageSets.latest.lix;
      })
    ];

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
      enableAllFirmware = true;
      enableAllHardware = true;
    };

    swapDevices = [
      {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}
    ];
  };
}
