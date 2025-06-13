{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: {
  options.mods.home.cli.nushell.enable = lib.mkEnableOption "enable nushell";

  config = lib.mkIf config.mods.home.cli.nushell.enable {
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
        configFile.text = /* nu */ ''
          source ${flakePath}/mods/home/cli/nushell/config.nu
        '';
        environmentVariables = config.home.sessionVariables;
        shellAliases = config.home.shellAliases;
      };
    };
  };
}
