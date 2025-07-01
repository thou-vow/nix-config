{
  inputs,
  lib,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    boot = {
      kernelModules = ["kvm-intel"];
      # kernelPackages = pkgs.linuxPackagesFor (import ./attuned-kernel.nix {inherit pkgs lib;});
      kernelPackages = pkgs.linuxKernel.packages.linux_zen;
      kernelParams = ["ath9k_core.nohwcrypt=1" "pcie_aspm=off"];
      loader.grub.configurationName = "Attuned";
    };

    hardware.enableRedistributableFirmware = true;

    networking.networkmanager.wifi.powersave = false;
  };
}
