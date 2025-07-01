{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland.";
  };

  config = lib.mkIf config.mods.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        # TODO: make a derivation that export scripts for these bindings
        bind = , XF86AudioMute, exec, amixer set Master toggle
        bind = , XF86AudioLowerVolume, exec, amixer set Master 1%-
        bind = , XF86AudioRaiseVolume, exec, amixer set Master 1%+
        bind = , XF86MonBrightnessDown, exec, brightnessctl set 1%-
        bind = , XF86MonBrightnessUp, exec, brightnessctl set 1%+
        bind = , Print, exec, grim -g "$(slurp)" - | swappy -f -
        bind = Super, T, exec, kitty -1
        bind = Super, B, exec, brave

        source = ${config.mods.flakePath}/mods/home/hyprland/hyprland.conf
      '';
    };

    home.packages = with pkgs; [
      alsa-utils
      brightnessctl
      grim
      slurp
      swappy
      wl-clipboard
    ];
  };
}
