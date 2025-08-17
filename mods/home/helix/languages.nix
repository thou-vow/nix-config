{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.mods.helix.enable {
    home.packages = with pkgs; [
      alejandra
      nixd
      rust-analyzer
      typescript-language-server
      typst-fmt
    ];

    programs.helix = {
      languages = {
        language = let
          commonIndent = {
            tab-width = 2;
            unit = " ";
          };
        in
          lib.map (language: language // {indent = commonIndent;}) [
            {
              name = "java";
            }
            {
              name = "json";
            }
            {
              name = "kdl";
            }
            {
              name = "nix";
              formatter.command = "alejandra";
            }
            {
              name = "rust";
            }
            {
              name = "typescript";
            }
            {
              name = "typst";
              formatter.command = "typst-fmt";
            }
            {
              name = "yaml";
            }
          ];

        language-server = {
          nixd = {
            args = ["--inlay-hints=true"];
            config.nixd = {
              formatting.command = ["alejandra"];
              nixpkgs.expr = ''import (builtins.getFlake "${inputs.self}").inputs.nixpkgs {}'';
            };
          };
          tinymist = {
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
