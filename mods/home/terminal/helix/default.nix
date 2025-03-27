{
  config,
  lib,
  ...
}:

{
  imports = [
    ./bindings.nix
    ./editor.nix
    ./languages.nix
  ];

  options.mods.home.terminal.helix = {
    enable = lib.mkEnableOption "helix";
  };

  config = lib.mkIf config.mods.home.terminal.helix.enable {
    home.shellAliases = {
      "h" = "hx";
      "helix" = "hx";
    };

    programs.helix = {
      enable = true;
      settings.theme = "theme";
    };

    xdg.configFile."helix/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/mods/home/terminal/helix/themes";
  };
}
