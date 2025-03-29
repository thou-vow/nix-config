{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ ../../../mods/home/home.nix ];

  mods.home = {
    terminal = {
      fastfetch.enable = true;
      helix.enable = true;
      nushell.enable = true;
      yazi.enable = true;
    };
  };

  home = {
    username = "thou";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      libqalculate # Calculator
      unimatrix # Simulate display from matrix
    ];
    stateVersion = "25.05";
  };

  programs = {
    alacritty.enable = true;
    brave.enable = true;
    helix = {
      languages.language-server.nixd.config.nixd.options = {
        "nixos".expr = ''(builtins.getFlake "${inputs.self}").nixosConfigurations."u".options'';
        "home-manager".expr = ''(builtins.getFlake "${inputs.self}").homeConfigurations."thou@u".options'';
      };
      settings.editor.statusline = {
        mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
      };
    };
    home-manager.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
