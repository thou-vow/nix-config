{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./languages.nix
  ];

  options.mods.helix = {
    enable = lib.mkEnableOption "Enable Helix.";
    package =
      lib.mkPackageOption inputs.nix-packages.legacyPackages.${pkgs.system} "helix" {default = "helix-steel";};
    extraConfigFile = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.mods.helix.enable {
    home.packages = with pkgs; [
      steel
    ];

    programs.helix = {
      enable = true;
      package = config.mods.helix.package;
      settings.editor = {
        bufferline = "always";
        color-modes = true;
        popup-border = "all";
        default-yank-register = "+";

        cursorcolumn = true;
        cursorline = true;
        line-number = "relative";
        text-width = 120;
        scrolloff = 3;

        idle-timeout = 0;
        completion-trigger-len = 1;
        completion-timeout = 0;
        completion-replace = true;

        cursor-shape = {
          normal = "bar";
          insert = "bar";
          select = "bar";
        };

        end-of-line-diagnostics = "hint";

        file-picker.hidden = false;

        indent-guides = {
          render = false;
          character = "▏";
          skip-levels = 1;
        };

        inline-diagnostics = {
          cursor-line = "disable";
          other-lines = "disable";
        };

        lsp = {
          enable = true;
          auto-signature-help = false;
          display-messages = true;
          display-inlay-hints = true;
        };

        search.smart-case = true;

        soft-wrap.enable = false;

        statusline = {
          left = [
            "mode"
            "separator"
            "workspace-diagnostics"
            "spinner"
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
            "file-modification-indicator"
            "separator"
            "read-only-indicator"
            "separator"
            "diagnostics"
            "separator"
            "position"
            "separator"
            "position-percentage"
          ];
          separator = "";
        };

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
      };
    };

    xdg.configFile = {
      "helix/init.scm".text =
        "(require \"${config.mods.flakePath}/mods/home/helix/init.scm\")"
        + lib.optionalString (config.mods.helix.extraConfigFile != null)
        "(require \"${config.mods.helix.extraConfigFile}\")";
      "helix/themes".source =
        config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/helix/themes";
    };
  };
}
