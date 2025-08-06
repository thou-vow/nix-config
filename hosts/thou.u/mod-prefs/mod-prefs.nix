{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  mods = {
    fastfetch.enable = true;
    fish.enable = true;
    flatpak.enable = true;
    fuzzel.enable = true;
    helix.enable = true;
    kitty.enable = true;
    niri.enable = true;
    prismlauncher.enable = true;
    waybar.enable = true;
    yazi.enable = true;
  };

  home.persistence = {
    "/nix/persist/plain/home/${config.home.username}" = {
      directories = [
        ".config/BraveSoftware"
        ".local/share/flatpak"
        ".local/share/zoxide"
        ".steam"
        ".var"
      ];
    };
    "/nix/persist/zstd3/home/${config.home.username}" = {
      directories = [
        ".local/share/PrismLauncher"
      ];
    };
  };

  programs = {
    helix = {
      languages.language-server.nixd.config.nixd.options = {
        nixos.expr = ''(builtins.getFlake "${inputs.self}").nixosConfigurations."u".options'';
        home-manager.expr = ''(builtins.getFlake "${inputs.self}").homeConfigurations."thou@u".options'';
      };
      settings.editor.statusline.mode = {
        normal = "NORMAL";
        insert = "INSERT";
        select = "SELECT";
      };
    };

    kitty.keybindings = {
      "alt+e" = "launch --stdin-source=@screen_scrollback ${lib.getExe pkgs.helix}";
    };
  };

  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/hosts/thou.u/mod-prefs/niri.kdl";
}
