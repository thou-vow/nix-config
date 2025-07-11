{
  config,
  inputs,
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
        kernelModules = ["xhci_pci" "ahci" "uas" "rtsx_usb_sdmmc"];
      };
      kernelModules = ["kvm-intel"];
      kernelPackages = inputs.chaotic.legacyPackages.${pkgs.system}.linuxPackages_cachyos.extend (final: prev: {
        kernel = prev.kernel.override (prevAttrs: {
          configfile = prevAttrs.configfile.overrideAttrs {
            installPhase = ''
              cp ${builtins.toFile "attuned-kernel-config" (builtins.readFile ./.attuned-kernel-config)} $out
            '';
          };
        });
      });
      kernelParams = ["ath9k_core.nohwcrypt=1" "pcie_aspm=off"];
      loader.grub.configurationName = "Attuned";
    };

    hardware.enableRedistributableFirmware = true;

    networking.networkmanager.wifi.powersave = false;
  };
}
