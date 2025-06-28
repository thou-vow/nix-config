{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.mods.helix.enable {
    programs.helix = {
      languages = {
        language = let
          commonIndent = {
            tab-width = 2;
            unit = " ";
          };
        in
          [
            {
              name = "json";
              indent = commonIndent;
            }
            {
              name = "kdl";
              formatter.command = lib.getExe pkgs.kdlfmt;
              indent = commonIndent;
            }
            {
              name = "nix";
              formatter.command = lib.getExe pkgs.alejandra;
              indent = commonIndent;
              language-servers = ["nixd"];
            }
            {
              name = "typescript";
              indent = commonIndent;
              language-servers = ["typescript-language-server"];
            }
            {
              name = "typst";
              indent = commonIndent;
              formatter.command = lib.getExe pkgs.typst-fmt;
              language-servers = ["tinymist"];
            }
          ]
          ++ lib.optionals config.mods.nushell.enable [
            {
              name = "nu";
              indent = commonIndent;
              language-servers = ["nu"];
            }
          ];

        language-server = {
          nixd = {
            command = lib.getExe pkgs.nixd;
            args = ["--inlay-hints=true"];
            config.nixd = {
              formatting.command = [(lib.getExe pkgs.alejandra)];
              nixpkgs.expr = ''import (builtins.getFlake "${inputs.self}").inputs.nixpkgs {}'';
            };
          };
          tinymist = {
            command = lib.getExe pkgs.tinymist;
            config = {
              exportPdf = "onSave";
              formatterMode = "typstyle";
            };
          };
          typescript-language-server = {
            command = lib.getExe pkgs.typescript-language-server;
          };
        };
      };
    };
  };
}
