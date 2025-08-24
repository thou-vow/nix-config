{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./attuned-nixos.nix
    ./drive-format.nix
    ./no-specialisation.nix
    inputs.impermanence.nixosModules.impermanence
  ];

  mods = {
    flakePath = "/flake";
    nh.enable = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      nix = final.lixPackageSets.latest.lix;
    })
  ];

  boot = {
    kernel.sysctl = {
      # Mostly performance improvements.
      "kernel.nmi_watchdog" = 0;
      "kernel.split_lock_mitigate" = 0;
      "vm.swappiness" = 10;
      "vm.dirty_background_ratio" = 2;
      "vm.dirty_ratio" = 5;

      # Virtual file system cache persists longer.
      "vm.vfs_cache_pressure" = 25;
    };
    kernelParams = [
      "zswap.enabled=1"

      # Heard that above 70% has a high penalty.
      "zswap.max_pool_percent=65"

      # Had a bad experience with cold memory shrink.
      "zswap.shrinker_enabled=0"
    ];
  };

  console = {
    colors = [
      "121622"
      "ea8f80"
      "6ac27f"
      "c7a84d"
      "92a8eb"
      "db8ad4"
      "52bcce"
      "aeb8d4"
      "7683a8"
      "f5b3a7"
      "7ae092"
      "e5c25f"
      "b3c4f5"
      "eaafe4"
      "6bd8ea"
      "ced4e6"
    ];
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment = {
    binsh = lib.getExe pkgs.dash;
    
    systemPackages = with pkgs; [
      btop
      cachix
      ncdu
      pciutils
      unzip
      usbutils
      util-linux
      zip
    ];

    variables = {
      MESA_SHADER_CACHE_MAX_SIZE = "10G";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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
    networkmanager.enable = true;
  };

  nix = {
    # Builds run with low priority so the system stays responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    # So the <angle-brackets> syntax uses flake inputs
    nixPath =
      lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    # So the flake#registry uses flake inputs
    registry =
      lib.mapAttrs (_: value: {flake = value;})
      (lib.filterAttrs (_: value: lib.isType "flake" value) inputs);

    settings = {
      experimental-features = ["flakes" "nix-command" "pipe-operator"];
      trusted-users = ["@wheel"];
    };
  };

  programs = {
    appimage.enable = true;
    firefox.enable = true;
    fish.enable = true;
    git.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        (runCommand "steamrun-lib" {} "mkdir $out; ln -s ${steam-run.fhsenv}/usr/lib64 $out/lib")
      ];
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.extraConfig = ''
      Defaults pwfeedback
      Defaults insults
    '';
  };

  services = {
    lvm.enable = false;
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
    xserver.xkb = {
      layout = "br,us";
      options = "caps:escape_shifted_capslock,grp:win_space_toggle";
    };
  };

  system.stateVersion = "25.11";

  systemd = {
    oomd.enable = false;

    services = let
      # Since the Home Manager configuration is standalone, to regenerate it automatically,
      #   in impermanence, a service is needed.
      # This runs between the login and shell in TTY, and also preserves specialisations.
      homeManagerActivateServices =
        lib.mapAttrs' (name: value:
          lib.nameValuePair "home-manager-activation-${name}" {
            description = "Run ${name} Home Manager activation";

            wantedBy = ["user-runtime-dir@${builtins.toString value.uid}.service"];
            before = ["user@${builtins.toString value.uid}.service"];

            path = [config.nix.package pkgs.dash];

            serviceConfig = {
              # Script to activate Home Manager's latest generation, considering specialisations.
              ExecStart = let
                currentSpecialisation = config.environment.etc."specialisation".text or null;
                activatePath =
                  lib.optionalString (currentSpecialisation != null) "specialisation/${currentSpecialisation}/"
                  + "activate";

                script = pkgs.writeShellScript "home-manager-activation" ''
                  #!/usr/bin/env dash

                  for gen in $(
                    nix-store -q --referrers \
                      $HOME/.local/state/nix/profiles/home-manager
                  ); do if [ -d "$gen/specialisation" ]; then
                      $gen/${activatePath}
                    fi
                  done
                '';
              in "${script}";
              RemainAfterExit = "yes";
              Type = "oneshot";
              User = name;
            };
          })
        # Only for users within home-manager group.
        (lib.filterAttrs (_: value: builtins.any (group: group == "home-manager") value.extraGroups)
          config.users.users);
    in
      homeManagerActivateServices
      // {
        # More system services could go here.
      };
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "America/Sao_Paulo";
  };

  users.users = {
    root.password = "123";
    thou = {
      uid = 1000;
      isNormalUser = true;
      description = "thou";
      extraGroups = ["home-manager" "networkmanager" "wheel"];
      password = "123";
      shell = pkgs.fish;
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
