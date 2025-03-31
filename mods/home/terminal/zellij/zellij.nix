{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mods.home.terminal.zellij.enable = lib.mkEnableOption "zellij";

  config = lib.mkIf config.mods.home.terminal.zellij.enable {
    programs.zellij.enable = true;

    xdg.configFile = {
      "zellij/config.kdl".text = ''
        default_mode "locked"
        mouse_mode false
        pane_frames false
        show_startup_tips false

        keybinds clear-defaults=true {
          locked {
            bind "Ctrl j" { ScrollDown; }
            bind "Ctrl Shift j" { HalfPageScrollDown; }
            bind "Ctrl k" { ScrollUp; }
            bind "Ctrl Shift k" { HalfPageScrollUp; }
          }
          normal {
            bind "0" { GoToTab 10; SwitchToMode "locked"; }
            bind "1" { GoToTab 1; SwitchToMode "locked"; }
            bind "2" { GoToTab 2; SwitchToMode "locked"; }
            bind "3" { GoToTab 3; SwitchToMode "locked"; }
            bind "4" { GoToTab 4; SwitchToMode "locked"; }
            bind "5" { GoToTab 5; SwitchToMode "locked"; }
            bind "6" { GoToTab 6; SwitchToMode "locked"; }
            bind "7" { GoToTab 7; SwitchToMode "locked"; }
            bind "8" { GoToTab 8; SwitchToMode "locked"; }
            bind "9" { GoToTab 9; SwitchToMode "locked"; }
            bind "+" { Resize "Increase"; SwitchToMode "locked"; }
            bind "-" { Resize "Decrease"; SwitchToMode "locked"; }
            bind "q" { CloseFocus; SwitchToMode "locked"; SwitchToMode "locked"; }
            bind "Shift q" { CloseTab; SwitchToMode "locked"; }
            bind "e" { EditScrollback; SwitchToMode "locked"; }
            bind "y" { NewPane "right"; SwitchToMode "locked"; }
            bind "Shift y" { NewPane "right"; MovePane "left"; SwitchToMode "locked"; }
            bind "a" { SwitchToMode "normal"; }
            bind "d" { Detach; SwitchToMode "locked"; }
            bind "f" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
            bind "Shift f" { ToggleFloatingPanes; SwitchToMode "locked"; }
            bind "h" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
            bind "Shift h" { MovePane "left"; SwitchToMode "locked"; }
            bind "j" { MoveFocus "down"; SwitchToMode "locked"; }
            bind "Shift j" { MovePane "down"; SwitchToMode "locked"; }
            bind "k" { MoveFocus "up"; SwitchToMode "locked"; }
            bind "Shift k" { MovePane "up"; SwitchToMode "locked"; }
            bind "l" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
            bind "Shift l" { MovePane "right"; SwitchToMode "locked"; }
            bind "n" { NewTab; SwitchToMode "locked"; SwitchToMode "locked"; }
            bind "x" { NewPane "down"; SwitchToMode "locked"; }
            bind "Shift x" { NewPane "down"; MovePane "up"; SwitchToMode "locked"; }
            bind "left" { Resize "Increase left"; SwitchToMode "locked"; }
            bind "Shift left" { Resize "Decrease left"; SwitchToMode "locked"; }
            bind "down" { Resize "Increase down"; SwitchToMode "locked"; }
            bind "Shift down" { Resize "Decrease down"; SwitchToMode "locked"; }
            bind "up" { Resize "Increase up"; SwitchToMode "locked"; }
            bind "Shift up" { Resize "Decrease up"; SwitchToMode "locked"; }
            bind "right" { Resize "Increase right"; SwitchToMode "locked"; }
            bind "Shift right" { Resize "Decrease right"; SwitchToMode "locked"; }
          }
          shared_except "locked" {
            bind "esc" { SwitchToMode "locked"; }
          }
          shared_except "normal" {
            bind "Ctrl space" { SwitchToMode "normal"; }
          }
        }

        plugins {
          zjstatus location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
            format_left               "#[fg=white,bg=bright_black,bold] {session} {mode} {tabs}"
            format_right              "{datetime}"

            mode_normal "#[fg=bright_black,bg=bright_blue] #[fg=bright_blue,bold,reverse]UNLOCKED #[fg=bright_blue]"
            mode_locked "#[fg=bright_black,bg=bright_red] #[fg=bright_red,bold,reverse] LOCKED  #[fg=bright_red]"

            tab_normal "#[] {name} {sync_indicator}{fullscreen_indicator}{floating_indicator}"
            tab_active "#[fg=bright_green,bold,italic] {name} {sync_indicator}{fullscreen_indicator}{floating_indicator}"
            tab_sync_indicator       "<> "
            tab_fullscreen_indicator "[] "
            tab_floating_indicator   "() "
            tab_display_count         "3"
            tab_truncate_start_format "#[]< +{count} ... "
            tab_truncate_end_format   "#[] ... +{count} >"

            datetime          "#[fg=bright_magenta,bold,reverse] {format} "
            datetime_format   "%d %b %Y  %H:%M:%S"
            datetime_timezone "America/Sao_Paulo"

          }
        }
      '';
      "zellij/layouts".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/mods/home/terminal/zellij/layouts";
    };
  };
}
