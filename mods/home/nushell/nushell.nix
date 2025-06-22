{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.nushell.enable = lib.mkEnableOption "enable nushell";

  config = lib.mkIf config.mods.home.nushell.enable {
    home.packages = with pkgs; [
      pokeget-rs
    ];

    programs = {
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      nushell = {
        enable = true;
        configFile.text = ''
          source ${flakePath}/mods/home/nushell/config.nu
        '';
        environmentVariables = config.home.sessionVariables;
        shellAliases = config.home.shellAliases;
      };
    };
  };
}
