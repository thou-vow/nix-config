{
  config,
  lib,
  ...
}: {
  options.mods.atuin = {
    enable = lib.mkEnableOption "Enable atuin.";
  };

  config = lib.mkIf config.mods.atuin.enable {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      settings = {
        inline_height = 10;
        prefers_reduced_motion = true;
        show_help = false;
        show_tabs = false;
        workspaces = true;
      };
    };
  };
}


