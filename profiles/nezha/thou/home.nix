{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ ../../../mods/home ];

  mods.home = {
    terminal = {
      fastfetch.enable = true;
      helix.enable = true;
      yazi.enable = true;
    };
  };

  home = {
    username = "thou";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.05";
    packages = with pkgs; [
      libqalculate # Calculator
      unimatrix # Simulate display from matrix
    ];
  };

  programs = {
    alacritty.enable = true;
    brave.enable = true;
    helix = {
      languages.language-server.nixd.config.nixd.options = {
        "nixos".expr = ''(builtins.getFlake "${inputs.self}").nixosConfigurations."nezha".options'';
        "home-manager".expr =
          ''(builtins.getFlake "${inputs.self}").homeConfigurations."thou@nezha".options'';
      };
      settings.editor.statusline = {
        mode.normal = "NORMAL";
        mode.insert = "INSERT";
        mode.select = "SELECT";
      };
    };
    home-manager.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
