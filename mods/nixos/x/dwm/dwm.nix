{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mods.nixos.x.dwm = {
    enable = lib.mkEnableOption "dwm";
  };

  config = lib.mkIf config.mods.nixos.x.dwm.enable {
    nixpkgs.overlays = [
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (finalAttrs: prevAttrs: {
          patches = [
            (prev.fetchpatch {
              url = "https://dwm.suckless.org/patches/actualfullscreen/dwm-actualfullscreen-20211013-cb3f58a.diff";
              hash = "sha256-vsTuudJCy7Zo1wdwpI/nY7Zu1txXx90QoDfJLmfDUH8=";
            })
            (prev.fetchpatch {
              url = "https://dwm.suckless.org/patches/alwayscenter/dwm-alwayscenter-20200625-f04cac6.diff";
              hash = "sha256-xQEwrNphaLOkhX3ER09sRPB3EEvxC73oNWMVkqo4iSY=";
            })
            (prev.fetchpatch {
              url = "https://dwm.suckless.org/patches/warp/dwm-warp-6.4.diff";
              hash = "sha256-8z41ld47/2WHNJi8JKQNw76umCtD01OUQKSr/fehfLw=";
            })
            (prev.fetchpatch {
              url = "https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.4.diff";
              hash = "sha256-+OXRqnlVeCP2Ihco+J7s5BQPpwFyRRf8lnVsN7rm+Cc=";
            })
            (prev.fetchpatch {
              url = "https://dwm.suckless.org/patches/rotatestack/dwm-rotatestack-20161021-ab9571b.diff";
              hash = "sha256-61WUl519vm57W0ALhQMXlX9tRh6kejoRaP3hIU8TawI=";
            })
            (prev.fetchpatch {
              url = "https://dwm.suckless.org/patches/alpha/dwm-alpha-20230401-348f655.diff";
              hash = "sha256-ZhuqyDpY+nQQgrjniQ9DNheUgE9o/MUXKaJYRU3Uyl4=";
            })
            ./xrdb-6.4.patch
            ./movestack-20211115-a786211.patch
            ./barpadding-6.2.patch
            ./notitle-6.2.patch
            ./use-env-variables.patch
            ./adjacenttag-6.2.patch
          ];

          configH = prev.writeText "config.h" ''
            #include <X11/XF86keysym.h>
            #include "movestack.c"

            static const unsigned int borderpx  = 1;
            static const unsigned int gappx     = 3;
            static const unsigned int snap      = 32;

            static const int showbar = 1;
            static const int topbar = 1;
            static const int vertpad = 5;
            static const int sidepad = 150;

            static const char *fonts[] = {"monospace:size=9"};

            static char normbgcolor[] = "#222222";
            static char normbordercolor[] = "#444444";
            static char normfgcolor[] = "#bbbbbb";
            static char selfgcolor[] = "#eeeeee";
            static char selbordercolor[] = "#005577";
            static char selbgcolor[] = "#005577";
            static const unsigned int baralpha = 0xd0;
            static const unsigned int borderalpha = OPAQUE;
            static char *colors[][3] = {
              [SchemeNorm] = {normfgcolor, normbgcolor, normbordercolor},
              [SchemeSel]  = {selfgcolor, selbgcolor, selbordercolor},
            };
            static const unsigned int alphas[][3] = {
              [SchemeNorm] = {OPAQUE, baralpha, borderalpha},
            	[SchemeSel] = {OPAQUE, baralpha, borderalpha},
            };

            static const char *tags[] = {"⬤", "⬤", "⬤", "⬤", "⬤", "⬤"};

            static const Rule rules[] = {
            	{"Spectacle", NULL, NULL, 0, 1, -1},
            };

            static const float mfact = 0.60;
            static const int nmaster = 1;
            static const int resizehints = 1;
            static const int lockfullscreen = 1;

            static const Layout layouts[] = {
            	{"[]=", tile},
            };

            #define BROWSER_ENVVAR "BROWSER"
            #define EXPLORER_ENVVAR "EXPLORER"
            #define LAUNCHER_ENVVAR "QUICKAPPS"
            #define TERMINAL_ENVVAR "TERMINAL"

            static const char *brightness_down[] = {"${lib.getExe pkgs.brightnessctl}", "set", "2%-", NULL};
            static const char *brightness_up[] = {"${lib.getExe pkgs.brightnessctl}", "set", "2%+", NULL};
            static const char *print[] = {"${lib.getExe pkgs.flameshot}", "gui", NULL};

            static const Key keys[] = {
              {0, XF86XK_MonBrightnessDown, spawn, {.v = brightness_down}},
              {0, XF86XK_MonBrightnessUp, spawn, {.v = brightness_up}},
              {0, XK_Print, spawn, {.v = print}},
              {Mod4Mask|ShiftMask, XK_9, rotatestack, {.i = -1}},
              {Mod4Mask|ShiftMask, XK_0, rotatestack, {.i = +1}},
            	{Mod4Mask, XK_minus, incnmaster, {.i = -1}},
            	{Mod4Mask, XK_equal, incnmaster, {.i = +1}},
            	{Mod4Mask, XK_q, killclient, {0}},
              {Mod4Mask, XK_e, spawn, {.v = explorercmd}},
            	{Mod4Mask, XK_t, spawn, {.v = termcmd}},
              {Mod4Mask, XK_f, togglefloating, {0}},
            	{Mod4Mask, XK_h, viewprev, {0}},
            	{Mod4Mask|ShiftMask, XK_h, tagtoprev, {0}},
              {Mod4Mask, XK_j, focusstack, {.i = +1}},
            	{Mod4Mask|ShiftMask, XK_j, movestack, {.i = +1}},
              {Mod4Mask, XK_k, focusstack, {.i = -1}},
            	{Mod4Mask|ShiftMask, XK_k, movestack, {.i = -1}},
            	{Mod4Mask, XK_l, viewnext, {0}},
            	{Mod4Mask|ShiftMask, XK_l, tagtonext, {0}},
            	{Mod4Mask, XK_z, togglefullscr, {0}},
              {Mod4Mask, XK_b, spawn, {.v = browsercmd}},
              {Mod4Mask, XK_Delete, quit, {0}},
              {Mod4Mask, XK_Return, spawn, {.v = dmenucmd}},
              {Mod4Mask, XK_Left, setmfact, {.f = -0.02}},
              {Mod4Mask, XK_Right, setmfact, {.f = +0.02}},
            };

            static const Button buttons[] = {
            	{ClkClientWin, Mod4Mask, Button1, movemouse, {0}},
            	{ClkClientWin, Mod4Mask|Mod1Mask, Button1, resizemouse, {0}},
            };
          '';

          postPatch = prevAttrs.postPatch + "cp ${finalAttrs.configH} config.h";
        });
      })
    ];

    services.xserver.windowManager.dwm.enable = true;

    environment.systemPackages = with pkgs; [
      dmenu
    ];
  };
}
