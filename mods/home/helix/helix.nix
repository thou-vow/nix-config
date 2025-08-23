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
    home.packages = with pkgs; [
      steel
    ];

    programs.helix = {
      enable = true;
      package = pkgs.helix-steel;
      settings.theme = "theme";
    };

    xdg.configFile = {
      "helix/helix.scm".text = ''
      '';
      "helix/init.scm".source = config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/helix/init.scm";
      "helix/themes".source =
        config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/helix/themes";
    };
  };
}
