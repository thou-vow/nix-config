{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.mods.prismlauncher.enable = lib.mkEnableOption "Enable Prismlauncher.";

  config = lib.mkIf config.mods.prismlauncher.enable {
    home = {
      extraDependencies = [
        # inputs.nix-packages.legacyPackages.${pkgs.system}.graalvm-oracle_21
      ];
      packages = with pkgs; [
        prismlauncher
      ];
    };
  };
}
