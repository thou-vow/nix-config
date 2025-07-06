{
  config,
  inputs,
  ...
}: {
  specialisation.attuned.configuration = {
    _module.args.pkgs = inputs.nixpkgs.lib.mkForce (import inputs.nixpkgs {
      config.allowUnfree = true;
      localSystem = {
        gcc.arch = "skylake";
        gcc.tune = "skylake";
        system = "x86_64-linux";
      };
      overlays = inputs.self.overlays ++ config.nixpkgs.overlays;
    });

    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = ["ath9k_core.nohwcrypt=1" "pcie_aspm=off"];
      loader.grub.configurationName = "Attuned";
    };

    hardware.enableRedistributableFirmware = true;

    networking.networkmanager.wifi.powersave = false;
  };
}
