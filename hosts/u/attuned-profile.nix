{
  inputs,
  pkgs,
  ...
}: {
  specialisation.attuned.configuration = {
    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = ["ath9k_core.nohwcrypt=1" "pcie_aspm=off"];
      loader.grub.configurationName = "Attuned";
    };

    hardware.enableRedistributableFirmware = true;

    networking.networkmanager.wifi.powersave = false;
  };
}
