{
  config,
  lib,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    nixpkgs.overlays = [
      (final: prev: {
        nix = final.lixPackageSets.latest.lix;
      })
    ];

    boot = {
      initrd = {
        includeDefaultModules = false;
        kernelModules = ["xhci_pci" "ahci" "uas"];
      };
      kernelPackages = pkgs.linuxPackagesFor (pkgs.linux-llvm.override {
        linux = pkgs.linux_latest;
        suffix = "attuned";
        useO3 = true;
        mArch = "skylake";
        withLTO = "thin";
        disableDebug = true;
        prependStructuredConfig = import ./kernel-localyesconfig.nix lib;
        features = {
          efiBootStub = true;
          ia32Emulation = true;
          netfilterRPFilter = true;
        };
      });
      kernelParams = [
        "ath9k_core.nohwcrypt=1"
        "pcie_aspm=off"
      ];
      loader.grub.configurationName = "Attuned";
    };

    environment.etc."specialisation".text = "attuned";

    hardware.enableRedistributableFirmware = true;

    networking.networkmanager.wifi.powersave = false;

    swapDevices = [
      {device = "/dev/disk/by-id/wwn-0x50014ee6b2ede306-part7";}
      {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}
    ];

    systemd.services =
      lib.mapAttrs' (name: value:
        lib.nameValuePair "hm-activation-${name}" {
          path = [config.nix.package pkgs.toybox];

          serviceConfig.ExecStart = ''
            ${
              pkgs.writeShellScript "hm-activation" ''
                #!${lib.getExe pkgs.dash}

                for gen in $(
                  nix-store -q --referrers \
                    /home/${name}/.local/state/nix/profiles/home-manager
                ); do if [ -d "$gen/specialisation" ]; then
                    "$gen/specialisation/attuned/activate"
                  fi
                done
              ''
            }'';
        })
      # Only for users within home-manager group
      (lib.filterAttrs (_: value: lib.lists.any (group: group == "home-manager") value.extraGroups)
        config.users.users);
  };
}
