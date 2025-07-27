{
  config,
  ...
}: {
  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    grub = {
      enable = true;
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd";
      efiInstallAsRemovable = true;
      efiSupport = true;
    };
  };

  environment.persistence = {
    "/nix/persist/zstd3" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/flake"
        "/root/.local/share/nix"
        "/var/log"
      ];
    };
    "/nix/persist/plain" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/ssh/ssh_host_ed25519_key"
        "/var/cache"
        "/var/lib"
      ];
      users.thou = {
        directories = [
          ".local/state/nix"
        ];
      };
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
    "/nix/persist/zstd3" = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part4";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=nix_persist_zstd3" "compress=zstd:3" "noatime"];
    };
    "/nix/store" = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part4";
      fsType = "btrfs";
      options = ["subvol=nix_store" "compress=zstd:5" "noatime" "nodatasum"];
    };
    "/nix/var" = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part4";
      fsType = "btrfs";
      options = ["subvol=nix_var" "compress=zstd:5" "noatime" "nodatasum"];
    };
    "/nix/persist/plain" = {
      device = "/dev/disk/by-id/wwn-0x500003988168a3bd-part5";
      fsType = "ext4";
      neededForBoot = true;
      options = ["commit=60" "data=writeback" "journal_async_commit" "noatime"];
    };
  };
}
