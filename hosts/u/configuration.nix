{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    tmp.cleanOnBoot = true;
    kernel.sysctl = {
      "vm.swappiness" = 1;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_bytes" = 1677216;
      "vm.dirty_bytes" = 50331648;
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "mitigations=off" ];
    loader = {
      efi.efiSysMountPoint = "/boot/efi";
      systemd-boot.enable = true;
    };
  };

  console.useXkbConfig = true;

  environment = {
    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
    systemPackages = with pkgs; [
      btop
      git
      sudo
      vim
      wget
      xclip
    ];
    variables = {
      CARGO_BUILD_JOBS = "1";
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  networking = {
    hostName = "u";
    nameservers = [
      "1.0.0.1"
      "1.1.1.1"
      "8.8.4.4"
      "8.8.8.8"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.scanRandMacAddress = false;
    };
    useDHCP = false;
  };

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      cores = 1;
      extra-experimental-features = "nix-command flakes pipe-operators";
      extra-trusted-users = [ "@wheel" ];
      max-jobs = 1;
      max-substitution-jobs = 1;
    };
  };

  programs.firefox.enable = true;

  security.rtkit.enable = true;

  services = {
    libinput = {
      enable = true;
      touchpad = {
        clickMethod = "clickfinger";
        naturalScrolling = true;
      };
    };
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    printing.enable = true;
    pulseaudio.enable = false;
    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 20;
      desktopManager.lxqt.enable = true;
      displayManager.lightdm.enable = true;
      xkb = {
        layout = "br,us";
        options = "caps:escape_shifted_capslock,grp:win_space_toggle";
      };
    };
  };

  time.timeZone = "America/Sao_Paulo";

  system.stateVersion = "25.05";

  users.users.thou = {
    isNormalUser = true;
    description = "thou";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = "${lib.getExe pkgs.nushell}";
  };
}
