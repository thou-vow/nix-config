{
  inputs,
  lib,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    boot = {
      # All kernel modules needed at stage 2 and initrd are declared here.
      initrd = {
        includeDefaultModules = false;
        kernelModules = [
          "xhci_pci"
          "ahci"
          "uas"
          "sd_mod"
        ];
      };
      kernelModules = ["kvm-intel"];

      kernelPackages = 
        # Since NixOS specialisation overlays aren't a thing,
        #  this is passed instead of `pkgs.linuxPackages_cachyos-lto`.
        lib.mkForce inputs.self.legacyPackages.${pkgs.system}.attunedPackages.linuxPackages_cachyos-lto;

      kernelParams = [
        # Disable CPU and GPU security mitigations for more performance.
        # (I might be overconfident that I'm safe...)
        "mitigations=off"
        "i915.mitigations=off"

        # I think these are needed for Wi-Fi to work properly
        "ath9k_core.nohwcrypt=1"
        "pcie_aspm=off"
      ];

      loader.grub.configurationName = "Attuned";
    };

    # For stuff to identify the current specialisation.
    environment.etc."specialisation".text = "attuned";

    hardware = {
      cpu.intel.updateMicrocode = true;
      enableRedistributableFirmware = true;
      graphics = {
        # Maybe worth the risk of breaking?
        package = pkgs.mesa_git;
        package32 = pkgs.mesa32_git;
      };
    };

    # Needed for Wi-Fi to not suddenly stop working...
    networking.networkmanager.wifi.powersave = false;

    swapDevices = [
      {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}

      # Memory swap on the internal HDD too.
      {device = "/dev/disk/by-id/wwn-0x50014ee6b2ede306-part7";}
    ];
  };
}
