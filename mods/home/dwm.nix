{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options.mods.dwm.enable = lib.mkEnableOption "dwm";

  config = lib.mkIf config.mods.dwm.enable {
    nixpkgs.overlays = [
      (final: prev: {
        dwm = inputs.suckless.packages.${final.system}.dwm.overrideAttrs (finalAttrs: prevAttrs: {
          configH = prev.writeText "config.h" ''
            #include <X11/XF86keysym.h>

            static const unsigned int borderpx  = 1;   /* border pixel of windows */
            static const unsigned int gappx     = 3;   /* gaps between windows */
            static const unsigned int snap      = 32;  /* snap pixel */

            static const int showbar            = 1;    /* 0 means no bar */
            static const int topbar             = 1;    /* 0 means bottom bar */
            static const char *fonts[]           = { "monospace:antialias=true:autohint=true:weight=demibold:size=10" };

            static const char main_cursor[]      = "#f4dbe2";
            static const char dark_background[]  = "#060810";
            static const char background[]       = "#121622";
            static const char dark_foreground[]  = "#aeb8d4";
            static const char foreground[]       = "#ced4e6";
            static const char *colors[][3]      = {
            	/*                fg                bg                border   */
            	[SchemeNorm]  = { dark_foreground,  dark_background,  dark_background },
            	[SchemeSel]   = { foreground,       background,       main_cursor  },
            };

            static const char *tags[] = { "א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט" };

            static Rule rules[] = {
            	/* class  instance  title  tags mask  isfloating  monitor */
            	{  NULL,  NULL,     NULL,  0,         False,      -1  },
            };

            static const float mfact     = 0.61;  /* factor of master area size [0.05..0.95] */
            static const int nmaster     = 1;     /* number of clients in master area */
            static const int resizehints = 0;     /* 1 means respect size hints in tiled resizals */
            static const int lockfullscreen = 0;  /* 1 will force focus on the fullscreen window */

            static const Layout layouts[] = {
            	/* symbol  arrange function */
            	{  "[]=",  tile  },    /* first entry is default */
              {  "TTT",  bstack },
              {  ">M>",  centeredfloatingmaster },
            	{  NULL,   NULL },   /* null should always be the last (for cyclelayouts) */
            };

            /* since dwm only updates after restarting the session, I don't want to hardcode these */
            static const char *audiotoggle[] = {"amixer", "set", "Master", "toggle", NULL};
            static const char *audiodown[] = {"amixer", "set", "Master", "1%-", NULL};
            static const char *audioup[] = {"amixer", "set", "Master", "1%+", NULL};
            static const char *brightnessdown[] = {"brightnessctl", "set", "1%-", NULL};
            static const char *brightnessup[] = {"brightnessctl", "set", "1%+", NULL};
            static const char *print[] = {"flameshot", "gui", NULL};
            static const char *termcmd[] = {"st", NULL};
            static const char *browsercmd[] = {"brave", NULL};

            static const Key keys[] = {
            	/* modifier             key                        function        argument */
              {  0,                   XF86XK_AudioMute,          spawn,          { .v = audiotoggle }  },
              {  0,                   XF86XK_AudioLowerVolume,   spawn,          { .v = audiodown }  },
              {  0,                   XF86XK_AudioRaiseVolume,   spawn,          { .v = audioup }  },
              {  0,                   XF86XK_MonBrightnessDown,  spawn,          { .v = brightnessdown }  },
              {  0,                   XF86XK_MonBrightnessUp,    spawn,          { .v = brightnessup }  },
            	{  0,                   XK_Print,                  spawn,          { .v = print }  },
              {  Mod4Mask,            XK_t,                      spawn,          { .v = termcmd }  },
              {  Mod4Mask,            XK_q,                      killclient,     {0}  },
              {  Mod4Mask,            XK_f,                      togglefloating, {0}  },
              {  Mod4Mask,            XK_h,                      viewprev,       {0}  },
              {  Mod4Mask|ShiftMask,  XK_h,                      tagtoprev,      {0}  },
              {  Mod4Mask,            XK_j,                      focusstack,     { .i = +1 }  },
              {  Mod4Mask|ShiftMask,  XK_j,                      cyclestack,     { .i = +1 }  },
            	{  Mod4Mask,            XK_k,                      focusstack,     { .i = -1 }  },
              {  Mod4Mask|ShiftMask,  XK_k,                      cyclestack,     { .i = -1 }  },
              {  Mod4Mask,            XK_l,                      viewnext,       {0}  },
              {  Mod4Mask|ShiftMask,  XK_l,                      tagtonext,      {0}  },
              {  Mod4Mask,            XK_comma,                  cyclelayout,    { .i = -1 }  },
            	{  Mod4Mask,            XK_period,                 cyclelayout,    { .i = +1 }  },
            	{  Mod4Mask,            XK_b,                      spawn,          { .v = browsercmd }  },
            	{  Mod4Mask,            XK_End,                    quit,           {0}  },
            };

            static const Button buttons[] = {
              /* click          event mask           button    function      argument */
            	{  ClkClientWin,  Mod4Mask,            Button1,  movemouse,    {0} },
            	{  ClkClientWin,  Mod4Mask|ShiftMask,  Button1,  resizemouse,  {0} },
            };
          '';

          postPatch = prevAttrs.postPatch + "cp ${finalAttrs.configH} config.h";
        });
      })
    ];

    home.packages = with pkgs; [
      alsa-utils
      brave
      brightnessctl
      flameshot
      st
      xclip
    ];

    xsession = {
      enable = true;
      windowManager.command = "exec ${lib.getExe pkgs.dwm}";
    };
  };
}
