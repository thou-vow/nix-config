{
  config,
  flakePath,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../mods/nixos/nixos.nix
    ./attuned-profile.nix
    ./default-profile.nix
    ./system-layout.nix
  ];

  mods.nixos = {
    x = {
      dwm.enable = true;
    };
  };

  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_bytes" = 1677216;
      "vm.dirty_bytes" = 50331648;
    };
    kernelParams = [
      "mitigations=off"
      "zswap.enabled=1"
      "zswap.accept_threshold_percent=0"
      "zswap.max_pool_percent=80"
    ];
    tmp.cleanOnBoot = false;
  };

  console.useXkbConfig = true;

  environment.systemPackages =
    (with pkgs; [
      btop
      fhs
      git
      nh
      nix-output-monitor
      sudo
      wget
      xclip
    ])
    ++ (with inputs.nixpkgs.legacyPackages.${pkgs.system}; [
      brightnessctl
      duf
      parted
      pciutils
      playerctl
      snake4
      vim
    ]);

  hardware = {
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware || config.hardware.enableAllFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit flakePath inputs;};
    useGlobalPkgs = true;
    users.thou = import ./thou/home-configuration.nix;
    useUserPackages = true;
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
    hostName = "u";
    nameservers = [
      "1.0.0.1"
      "1.1.1.1"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    registry = lib.mapAttrs (_: value: {flake = value;}) (lib.filterAttrs (_: value: lib.isType "flake" value) inputs);

    settings = {
      experimental-features = ["flakes" "nix-command" "pipe-operator"];
      flake-registry = "";
      system-features = ["gccarch-skylake"];
      trusted-users = ["@wheel"];
    };
  };

  programs = {
    appimage.enable = true;
    firefox.enable = true;
  };

  security.rtkit.enable = true;

  services = {
    flatpak.enable = true;
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
    pulseaudio.enable = false;
    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 20;
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
      xkb = {
        layout = "br,us";
        options = "caps:escape_shifted_capslock,grp:win_space_toggle";
      };
    };
  };

  system.stateVersion = "25.05";

  time.timeZone = "America/Sao_Paulo";

  users.users = {
    thou = {
      isNormalUser = true;
      description = "thou";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = lib.getExe pkgs.bash;
    };
  };
}
