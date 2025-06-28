{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.nushell.enable = lib.mkEnableOption "enable nushell";

  config = lib.mkIf config.mods.nushell.enable {
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
        configFile.text =
          # nu
          ''
            source ${config.mods.flakePath}/mods/home/nushell/config.nu
          '';
        environmentVariables = config.home.sessionVariables;
        shellAliases = config.home.shellAliases;
      };
    };
  };
}
