{
  config,
  flakePath,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./bindings.nix
    ./editor.nix
    ./languages.nix
  ];

  options.mods.home.cli.helix = {
    enable = lib.mkEnableOption "helix";
  };

  config = lib.mkIf config.mods.home.cli.helix.enable {
    nixpkgs.overlays = [
      (final: prev: {
        helix = inputs.helix.packages.${final.system}.helix;
      })
    ];

    programs.helix = {
      enable = true;
      settings.theme = "catppuccin_frappe";
    };

    xdg.configFile."helix/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/mods/home/cli/helix/themes";
  };
}
