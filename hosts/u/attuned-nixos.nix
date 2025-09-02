{
  lib,
  inputs,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    boot = {
      # All kernel modules are statically linked
      initrd = {
        availableKernelModules = lib.mkForce [];
        kernelModules = lib.mkForce [];
      };
      kernelModules = lib.mkForce [];

      kernelPackages = pkgs.linuxPackagesFor (
        inputs.nix-packages.legacyPackages.${pkgs.system}.attunedPackages.linux-llvm
      );

      kernelParams = [
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
        package = inputs.chaotic.packages.${pkgs.system}.mesa_git;
        package32 = inputs.chaotic.packages.${pkgs.system}.mesa32_git;
      };
    };

    # Needed for Wi-Fi to not suddenly stop working...
    networking.networkmanager.wifi.powersave = false;

    swapDevices = [
      {
        device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";
        priority = 0;
      }

      # Memory swap on the internal HDD too.
      {
        device = "/dev/disk/by-id/wwn-0x50014ee6b2ede306-part7";
        priority = 0;
      }
    ];

    systemd.services = {
      # Setting i915.mitigations=off kernel parameter (to disable GPU security mitigations)
      #  freezes inital ramdisk for the custom kernel.
      # So, it's done instead with this service.
      disable-i915-mitigations = {
        description = "Set i915 (Intel Graphics) mitigations off at runtime";
        wantedBy = ["multi-user.target"];
        before = ["graphical.target"];
        serviceConfig = {
          ExecStart = let
            script = pkgs.writeShellScript "disable-i915-mitigations" ''
              if [ -w /sys/module/i915/parameters/mitigations ]; then
                echo off > /sys/module/i915/parameters/mitigations
              fi
            '';
          in "${script}";
          Type = "oneshot";
          RemainAfterExit = "yes";
        };
      };
    };
  };
}
