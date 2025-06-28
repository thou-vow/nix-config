{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.prismlauncher.enable = lib.mkEnableOption "prismlauncher";

  config = lib.mkIf config.mods.prismlauncher.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];

    # home.file.".store-aliases/graalvm-oracle_21".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.graalvm-oracle_21}";
  };
}
