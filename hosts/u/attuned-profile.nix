{
  inputs,
  pkgs,
  ...
}: let
  # It has no overlays yet
  attunedPkgs = import inputs.nixpkgs {
    localSystem = {
      gcc.arch = "skylake";
      gcc.tune = "skylake";
      system = pkgs.system;
    };
  };
in {
  specialisation.attuned.configuration = {
    boot = {
      kernelModules = ["kvm-intel"];
      kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_xanmod_latest);
      kernelParams = ["ath9k_core.nohwcrypt=1" "pcie_aspm=off"];
      loader.grub.configurationName = "Attuned";
    };

    hardware.enableRedistributableFirmware = true;

    networking.networkmanager.wifi.powersave = false;
  };
}
