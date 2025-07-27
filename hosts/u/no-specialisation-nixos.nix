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

    systemd.services =
      lib.mapAttrs' (name: value:
        lib.nameValuePair "hm-activation-${name}" {
          path = [config.nix.package pkgs.home-manager pkgs.toybox];

          serviceConfig.ExecStart = ''
            ${
              pkgs.writeShellScript "hm-activation" ''
                #!${lib.getExe pkgs.dash}

                for gen in $(
                  nix-store -q --referrers \
                    /home/${name}/.local/state/nix/profiles/home-manager
                ); do if [ -d "$gen/specialisation" ]; then
                    "$gen/activate"
                  fi
                done
              ''
            }'';
        })
      # Only for users within home-manager group
      (lib.filterAttrs (_: value: builtins.any (group: group == "home-manager") value.extraGroups)
        config.users.users);
  };
}
