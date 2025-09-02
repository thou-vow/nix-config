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
      fish-lsp
      jdt-language-server
      kdlfmt
      llvmPackages_latest.lldb
      llvmPackages_latest.clang-tools
      nixd
      rust-analyzer
      rustfmt
      tinymist
      typescript-language-server
      typstyle
      vscode-css-languageserver
      vscode-json-languageserver
      yaml-language-server
      yamlfmt
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
              name = "c";
            }
            {
              name = "css";
            }
            {
              name = "fish";
            }
            {
              name = "java";
            }
            {
              name = "javascript";
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
              formatter.command = "typstyle";
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
