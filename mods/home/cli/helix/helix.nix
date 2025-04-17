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

  options.mods.home.cli.helix = {
    enable = lib.mkEnableOption "helix";
  };

  config = lib.mkIf config.mods.home.cli.helix.enable {
    programs.helix = {
      enable = true;
      package = pkgs.inputs.helix;
      settings.theme = "theme";
    };

    xdg.configFile."helix/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/mods/home/cli/helix/themes";
  };
}
