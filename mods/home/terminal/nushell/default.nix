{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mods.nushell.enable = lib.mkEnableOption "enable nushell";

  config = lib.mkIf config.mods.nushell.enable {
    home.packages = with pkgs; [
      pokeget-rs
    ];

    programs.nushell = {
      enable = true;
    };

    xdg.configFile."nushell/config.nu".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/mods/home/terminal/nushell/config.nu";
  };
}
