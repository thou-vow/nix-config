{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.mods.home.cli.helix.enable {
    programs.helix = {
      languages = {
        language = let
          commonIndent = {
            tab-width = 2;
            unit = "	";
          };
        in [
          {
            name = "kdl";
            auto-format = true;
            formatter.command = lib.getExe pkgs.kdlfmt;
            indent = commonIndent;
          }
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.alejandra;
            indent = commonIndent;
            language-servers = ["nixd"];
          }
          {
            name = "typst";
            indent = commonIndent;
            formatter.command = "${lib.getExe pkgs.typst-fmt}";
            language-servers = ["tinymist"];
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
            command = "${lib.getExe pkgs.tinymist}";
            config = {
              exportPdf = "onSave";
              formatterMode = "typstyle";
            };
          };
        };
      };
    };
  };
}
