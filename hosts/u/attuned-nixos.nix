{
  inputs,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    nixpkgs.overlays = [
      (final: prev: {
        # nix = final.lixPackageSets.latest.lix.override {
        #   stdenv = final.withCFlags ["-O3" "-march=skylake" "-flto"] prev.clangStdenv;
        # };
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
          configfile = prevAttrs.configfile.overrideAttrs (prevAttrs': {
            installPhase = ''
              cp ${builtins.toFile "attuned-kernel-config" (builtins.readFile ./.attuned-kernel-config)} $out
            '';

            passthru = prevAttrs'.passthru // {kernelPatches = prevAttrs'.passthru.kernelPatches ++ [./target-skylake.patch];};
          });
        });
      });
      kernelParams = [
        "ath9k_core.nohwcrypt=1"
        "pcie_aspm=off"
      ];
      loader.grub.configurationName = "Attuned";
    };

    hardware.enableRedistributableFirmware = true;

    networking.networkmanager.wifi.powersave = false;

    nix.package = pkgs.lixPackageSets.latest.lix;

    swapDevices = [
      {device = "/dev/disk/by-id/wwn-0x50014ee6b2ede306-part7";}
      {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}
    ];
  };
}
