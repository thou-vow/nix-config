{
  config,
  lib,
  ...
}: {
  options.mods.home.picom = {
    enable = lib.mkEnableOption "picom";
  };

  config = lib.mkIf config.mods.home.picom.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      fade = true;
    };

    xsession.initExtra = ''
      systemctl --user restart picom
    '';
  };
}
