{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../mods/nixos/nixos.nix
  ];

  boot = {
    tmp.cleanOnBoot = true;
    kernel.sysctl = {
      "vm.swappiness" = 1;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_bytes" = 1677216;
      "vm.dirty_bytes" = 50331648;
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [
      "mitigations=off"
      "zswap.enabled=1"
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      btop
      duf
      pciutils
      sudo
      xclip
    ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  networking = {
    hostName = "lc";
    nameservers = [
      "1.0.0.1"
      "1.1.1.1"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = false;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;

    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    registry =
      inputs
      |> lib.filterAttrs (_: value: lib.isType "flake" value)
      |> lib.mapAttrs (_: value: {flake = value;});

    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command" "pipe-operators"];
      flake-registry = "";
      trusted-users = ["root" "@wheel"];
    };
  };

  programs = {
    appimage.enable = true;
    git.enable = true;
    firefox.enable = true;
  };

  services = {
    flatpak.enable = true;
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
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
      desktopManager.cinnamon.enable = true;
      displayManager.lightdm.enable = true;
      xkb.layout = "br";
    };
  };

  system.stateVersion = "25.05";

  time.timeZone = "America/Sao_Paulo";

  users.users = {
    lc = {
      isNormalUser = true;
      description = "lc";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        gimp
        gnome-gnome-text-editor
        libreoffice-bin
        melonDS
        mgba
        steam
        ppsspp
        vesktop
      ];
      shell = "${lib.getExe pkgs.nushell}";
    };
  };
}
