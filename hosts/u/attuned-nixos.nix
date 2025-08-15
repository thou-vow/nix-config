{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    boot = {
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

      kernelPackages = pkgs.linuxPackagesFor (
        inputs.self.legacyPackages.${pkgs.system}.attunedPackages.linux-llvm
      );

      kernelParams = [
        "ath9k_core.nohwcrypt=1"
        "mitigations=off"
        "pcie_aspm=off"
      ];
      loader.grub.configurationName = "Attuned";
    };

    environment.etc."specialisation".text = "attuned";

    hardware = {
      enableRedistributableFirmware = true;
      graphics = {
        package = pkgs.mesa_git;
        package32 = pkgs.mesa32_git;
      };
    };

    networking.networkmanager.wifi.powersave = false;

    services.scx = {
      enable = true;
      scheduler = "scx_rusty";
      package = pkgs.scx_git.full;
    };

    swapDevices = [
      {device = "/dev/disk/by-id/wwn-0x50014ee6b2ede306-part7";}
      {device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part3";}
    ];

    systemd.services =
      lib.mapAttrs' (name: value:
        lib.nameValuePair "hm-activation-${name}" {
          path = [config.nix.package];

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
        config.users.users)
      // {
        # Setting i915.mitigations=off parameter freezes inital ramdisk for the custom kernel
        # So, it's done at runtime instead
        disable-i915-mitigations = {
          description = "Set i915 (Intel Graphics) mitigations off at runtime";
          wantedBy = ["multi-user.target"];
          before = ["graphical.target"];
          serviceConfig = {
            ExecStart = ''${pkgs.writeShellScript "disable-i915-mitigations" ''
                if [ -w /sys/module/i915/parameters/mitigations ]; then
                  echo off > /sys/module/i915/parameters/mitigations
                fi
              ''}'';
            Type = "oneshot";
            RemainAfterExit = "yes";
          };
        };
      };
  };
}
