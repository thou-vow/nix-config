{config, ...}: {
  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    grub = {
      enable = true;
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd";
      efiInstallAsRemovable = true;
      efiSupport = true;
    };
  };

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/flake"
      "/root/.local/share/nix"
      "/var/log"
    ];
    users.thou = {
      directories = [
        ".cache/mesa_shader_cache"
        ".cache/nix"
        ".local/state/nix"
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["mode=755" "noatime" "size=100%"];
    };
    ${config.boot.loader.efi.efiSysMountPoint} = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part2";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
    "/nix/store" = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part4";
      fsType = "btrfs";
      options = ["subvol=nix_store" "compress=zstd:5" "noatime" "nodatasum"];
    };
    "/nix/var" = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part4";
      fsType = "btrfs";
      options = ["subvol=nix_var" "compress=zstd:5" "noatime"];
    };
    "/persist" = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part4";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=nix_persist_zstd3" "compress=zstd:3" "noatime"];
    };
  };
}
