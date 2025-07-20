{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.fish.enable = lib.mkEnableOption "Enable Fish.";

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

        interactiveShellInit = lib.mkAfter ''
          source "${config.mods.flakePath}/mods/home/fish/interactive-init.fish"
        '';

        preferAbbrs = true;
        shellAbbrs = config.programs.fish.shellAliases;
      };

      bat.enable = true;

      eza = {
        enable = true;
        enableFishIntegration = true;
        extraOptions = [
          "--group-directories-first"
          "--icons"
        ];
      };

      fd.enable = true;

      ripgrep.enable = true;

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
    };

    home.packages = with pkgs; [
      pokeget-rs
    ];
  };
}
