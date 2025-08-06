{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./bindings.nix
    ./editor.nix
    ./languages.nix
  ];

  options.mods.helix = {
    enable = lib.mkEnableOption "Enable Helix.";
  };

  config = lib.mkIf config.mods.helix.enable {
    programs.helix = {
      enable = true;
      package = pkgs.helix_mod;
      settings.theme = "theme";
    };

    xdg.configFile."helix/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/helix/themes";
  };
}
