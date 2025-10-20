{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.mods.helix = {
    enable = lib.mkEnableOption "Helix Editor";
    package =
      lib.mkPackageOption inputs.nix-packages.legacyPackages.${pkgs.system} "helix" {default = "helix-steel";};
    extraInitFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf config.mods.helix.enable {
    home.packages = with pkgs; [
      clippy
      fish-lsp
      jdt-language-server
      llvmPackages_latest.lldb
      llvmPackages_latest.clang-tools
      nixd
      rust-analyzer
      steel
      typescript-language-server
      vscode-css-languageserver
      vscode-json-languageserver
      yaml-language-server
    ];

    programs.helix = {
      enable = true;
      package = config.mods.helix.package;
    };

    xdg.configFile = {
      "helix/init.scm".text =
        ''
          (require "${config.mods.flakePath}/mods/home/helix/init.scm")
        ''
        + lib.optionalString (config.mods.helix.extraInitFile != null) ''
          (require "${config.mods.helix.extraInitFile}")
        '';
      "helix/themes".source =
        config.lib.file.mkOutOfStoreSymlink "${config.mods.flakePath}/mods/home/helix/themes";
    };
  };
}
