{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
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
              "$gen/specialisation/attuned/activate"
            fi
          done
        '';

        nix = final.lixPackageSets.latest.lix;
      })
    ];

    boot = {
      initrd = {
        includeDefaultModules = false;
        kernelModules = ["xhci_pci" "ahci" "uas"];
      };
      kernelModules = ["kvm-intel"];
      kernelPackages = inputs.chaotic.legacyPackages.${pkgs.system}.linuxPackages_cachyos-lto;
      kernelParams = [
        "ath9k_core.nohwcrypt=1"
        "pcie_aspm=off"
      ];
      loader.grub.configurationName = "Attuned";
    };

    hardware.enableRedistributableFirmware = true;

    networking.networkmanager.wifi.powersave = false;

    swapDevices = [
      {device = "/dev/disk/by-id/wwn-0x50014ee6b2ede306-part7";}
      {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}
    ];
  };
}
