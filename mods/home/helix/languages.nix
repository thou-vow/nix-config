{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.mods.helix.enable {
    home.packages = with pkgs; [
      clippy
      fish-lsp
      jdt-language-server
      llvmPackages_latest.lldb
      llvmPackages_latest.clang-tools
      nixd
      rust-analyzer
      typescript-language-server
      vscode-css-languageserver
      vscode-json-languageserver
      yaml-language-server
    ];

    programs.helix.languages = {
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
          }
          {
            name = "rust";
          }
          {
            name = "scheme";
            language-servers = ["steel-language-server"];
          }
          {
            name = "typescript";
          }
          {
            name = "typst";
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
        rust-analyzer.config.check.command = "clippy";
        steel-language-server.command = "steel-language-server";
        tinymist.config.exportPdf = "onSave";
      };
    };
  };
}
