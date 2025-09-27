{
  config,
  lib,
  ...
}: {
  options.mods.zoxide.enable = lib.mkEnableOption "zoxide";

  config = lib.mkIf config.mods.zoxide.enable {
    home.shellAliases = {
      "cd" = "z";
      "ci" = "zi";
    };

    programs.zoxide = {
      enable = true;
    };
  };
}
