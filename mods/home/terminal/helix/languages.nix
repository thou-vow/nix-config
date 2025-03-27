{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.mods.home.terminal.helix.enable {
    programs.helix = {
      languages = {
        language =
          let
            commonIndent = {
              tab-width = 2;
              unit = "	";
            };
          in
          [
            {
              name = "kdl";
              indent = commonIndent;
              auto-format = true;
            }
            {
              name = "nix";
              indent = commonIndent;
              auto-format = true;
              formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
              language-servers = [ "nixd" ];
            }
          ];

        language-server = {
          nixd = {
            command = lib.getExe pkgs.nixd;
            args = [ "--inlay-hints=true" ];
            config.nixd = {
              formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
              nixpkgs.expr = ''import (builtins.getFlake "${inputs.self}").inputs.nixpkgs {}'';
            };
          };
        };
      };
    };
  };
}
