{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.prismlauncher.enable = lib.mkEnableOption "Enable Prismlauncher.";

  config = lib.mkIf config.mods.prismlauncher.enable {
    home = {
      extraDependencies = with pkgs; [
        graalvm-oracle
        graalvm-oracle_21
      ];
      packages = with pkgs; [
        prismlauncher
      ];
      persistence."/nix/persist/zstd3/home/${config.home.username}".directories = [
        ".local/share/PrismLauncher"
      ];
    };
  };
}
