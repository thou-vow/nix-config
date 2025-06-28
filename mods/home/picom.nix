{
  config,
  lib,
  ...
}: {
  options.mods.picom = {
    enable = lib.mkEnableOption "picom";
  };

  config = lib.mkIf config.mods.picom.enable {
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
