{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.fhs.enable = lib.mkEnableOption "Enable Filesystem Hierarchy Standard.";

  config = lib.mkIf config.mods.fhs.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        (runCommand "steamrun-lib" {} "mkdir $out; ln -s ${steam-run.fhsenv}/usr/lib64 $out/lib")
      ];
    };

    # system.activationScripts.binsh = lib.mkForce "";

    # systemd = {
    #   mounts."/bin" = {
    #     what = "/run/current-system/sw/bin";
    #     where = "/bin";
    #     type = "none";
    #     options = "bind";
    #     wantedBy = ["local-fs.target"];
    #   };
    #   tmpfiles.rules = [
    #     "d /bin 0755 root root -"
    #   ];
    # };
  };
}

