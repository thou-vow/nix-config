{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./attuned-nixos.nix
    ./core.nix
    ./default-nixos.nix
    ../../mods/nixos/nixos.nix
  ];

  mods = {
    flakePath = "/flake";
  };

  nixpkgs.overlays = [
    (final: prev: {
      sudo = prev.sudo.override {withInsults = true;};
    })
  ];

  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 80;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_bytes" = 1677216;
      "vm.dirty_bytes" = 50331648;
    };
    kernelParams = [
      "mitigations=off"
      "zswap.enabled=1"
      "zswap.accept_threshold_percent=90"
      "zswap.max_pool_percent=80"
    ];
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
    btop
    brightnessctl
    cachix
    fhs
    home-manager
    ncdu
    nh
    nix-output-monitor
    playerctl
    ripgrep
    sudo
    util-linux
  ];

  hardware = {
    cpu.intel.updateMicrocode =
      config.hardware.enableRedistributableFirmware
      || config.hardware.enableAllFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
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

    nixPath =
      lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry
      ++ [
        "nixos-config=${config.mods.flakePath}"
      ];

    registry =
      lib.mapAttrs (_: value: {flake = value;})
      (lib.filterAttrs (_: value: lib.isType "flake" value) inputs);

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
    git.enable = true;
    nix-ld.enable = true;
  };

  security.rtkit.enable = true;

  services = {
    libinput = {
      enable = true;
      touchpad = {
        clickMethod = "clickfinger";
        naturalScrolling = true;
      };
    };
    logind.powerKey = "suspend";
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
  };

  system.stateVersion = "25.05";

  systemd.user.services."hm-activate" = {
    enable = true;
    description = "Activate home-manager at login";

    wantedBy = ["default.target"];
    before = ["graphical-session.target"];

    path = [config.nix.package pkgs.home-manager pkgs.toybox];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      TimeoutStartSec = "5m";
      SyslogIdentifier = "hm-activate";
      ExecStart = "${pkgs.writeShellScript "hm-activate" ''
        #!${lib.getExe pkgs.dash}
        $(home-manager generations | head -1 | cut -d ' ' -f7)/activate
      ''}";
    };

    unitConfig.ConditionUser = "thou";
  };

  time.timeZone = "America/Sao_Paulo";

  users.users = {
    root.password = "123";
    thou = {
      isNormalUser = true;
      description = "thou";
      extraGroups = ["networkmanager" "wheel"];
      password = "123";
      shell = lib.getExe pkgs.bash;
    };
  };
}
