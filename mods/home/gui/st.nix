{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.gui.st.enable = lib.mkEnableOption "st";

  config = lib.mkIf config.mods.home.gui.st.enable {
    home.packages = [
      pkgs.inputs.st
    ];
  };
}
