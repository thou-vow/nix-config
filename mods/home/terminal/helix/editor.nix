{ config, lib, ... }:

{
  config = lib.mkIf config.mods.home.terminal.helix.enable {
    programs.helix.settings.editor = {
      mouse = false;
      bufferline = "always";
      cursorcolumn = true;
      cursorline = true;
      line-number = "relative";
      completion-trigger-len = 1;
      completion-timeout = 0;
      idle-timeout = 0;
      auto-pairs = true;
      text-width = 120;
      color-modes = true;
      popup-border = "all";
      scrolloff = 5;
      end-of-line-diagnostics = "hint";
      inline-diagnostics = {
        cursor-line = "disable";
        other-lines = "disable";
      };

      statusline = {
        left = [
          "mode"
          "separator"
          "workspace-diagnostics"
          "spinner"
          "separator"
          "read-only-indicator"
          "separator"
          "selections"
          "separator"
          "register"
        ];
        center = [
          "file-name"
          "separator"
          "version-control"
        ];
        right = [
          "diagnostics"
          "separator"
          "position"
          "separator"
          "position-percentage"
        ];
        # Don't change while theming doesn't support
        # "ui.statusline.separator.inactive"
        separator = "";
      };

      lsp = {
        enable = true;
        auto-signature-help = false;
        display-messages = true;
        display-inlay-hints = true;
      };

      file-picker.hidden = false;

      search.smart-case = true;

      whitespace = {
        render = {
          space = "none";
          tab = "none";
          nbsp = "none";
          nnbsp = "none";
          newline = "none";
        };
        characters = {
          space = "·";
          nbsp = "⍽";
          nnbsp = "␣";
          tab = "→";
          newline = "⏎";
          tabpad = "·";
        };
      };
      indent-guides = {
        render = false;
        character = "▏";
        skip-levels = 1;
      };
      soft-wrap.enable = false;
    };
  };
}
