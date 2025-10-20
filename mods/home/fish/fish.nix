{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.fish = {
    enable = lib.mkEnableOption "fish";
    extraInteractiveShellInitFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf config.mods.fish.enable {
    programs = {
      fish = {
        enable = true;

        plugins = with pkgs.fishPlugins; [
          {
            name = "autopair";
            src = autopair.src;
          }
          {
            name = "bass";
            src = bass.src;
          }
          {
            name = "puffer";
            src = puffer.src;
          }
        ];

        interactiveShellInit = lib.mkAfter (''
            source "${config.mods.flakePath}/mods/home/fish/interactive.fish"
          ''
          + lib.optionalString (config.mods.fish.extraInteractiveShellInitFile != null) ''
            source "${config.mods.fish.extraInteractiveShellInitFile}"
          '');

        preferAbbrs = true;
        shellAbbrs = config.programs.fish.shellAliases;
      };

      bat.enable = true;

      eza = {
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--icons"
        ];
      };

      fd.enable = true;

      fzf.enable = true;

      ripgrep.enable = true;
    };

    home.packages = with pkgs; [
      pokeget-rs
    ];
  };
}
