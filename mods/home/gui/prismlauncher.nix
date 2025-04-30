{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.gui.prismlauncher.enable = lib.mkEnableOption "prismlauncher";

  config = lib.mkIf config.mods.home.gui.prismlauncher.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];

    # home.file.".store-aliases/graalvm-oracle_21".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.custom.graalvm-oracle_21}";
  };
}
