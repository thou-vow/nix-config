{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./bindings.nix
    ./editor.nix
    ./languages.nix
  ];

  options.mods.helix = {
    enable = lib.mkEnableOption "helix";
  };

  config = lib.mkIf config.mods.helix.enable {
    nixpkgs.overlays = [
      (final: prev: {
        helix = inputs.helix.packages.${final.system}.helix;
      })
    ];

    programs.helix = {
      enable = true;
      settings.theme = "theme";
    };

    xdg.configFile."helix/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/helix/themes";
  };
}
