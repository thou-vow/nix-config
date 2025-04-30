{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../mods/nixos/nixos.nix
  ];

  boot.tmp.cleanOnBoot = true;

  environment = {
    systemPackages = with pkgs; [
      btop
      duf
      git
      pciutils
      snake4
      sudo
      vim
      wget
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

  networking.hostName = "u";

  nix = {
    package = pkgs.nixVersions.git;

    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    registry = lib.mapAttrs (_: value: {flake = value;}) (lib.filterAttrs (_: value: lib.isType "flake" value) inputs);

    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command" "pipe-operators"];
      flake-registry = "";
      trusted-users = ["@wheel"];
    };
  };

  programs = {
    appimage.enable = true;
    firefox.enable = true;
    nh.enable = true;
  };

  security.rtkit.enable = true;

  services = {
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
    xserver.enable = true;
  };

  system.stateVersion = "25.05";

  time.timeZone = "America/Sao_Paulo";

  users.users.thou = {
    isNormalUser = true;
    description = "thou";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  wsl.enable = true;
}
