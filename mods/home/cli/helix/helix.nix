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
    programs.helix = {
      enable = true;
      settings.theme = "catppuccin_frappe";
    };

    xdg.configFile."helix/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/mods/home/cli/helix/themes";
  };
}
