{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.prismlauncher = {
    enable = lib.mkEnableOption "Prismlauncher";
    jdks = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "JDK packages for Prismlauncher.";
    };
  };

  config = lib.mkIf config.mods.prismlauncher.enable {
    home.packages = with pkgs; [
      (prismlauncher.override {
        inherit (config.mods.prismlauncher) jdks;
      })
    ];
  };
}
