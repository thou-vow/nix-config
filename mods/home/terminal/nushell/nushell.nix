{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mods.home.terminal.nushell.enable = lib.mkEnableOption "enable nushell";

  config = lib.mkIf config.mods.home.terminal.nushell.enable {
    home.packages = with pkgs; [
      pokeget-rs
    ];

    programs.nushell = {
      enable = true;
      configFile.text = ''
        source ${config.home.homeDirectory}/nix/mods/home/terminal/nushell/config.nu
      '';
    };
  };
}
