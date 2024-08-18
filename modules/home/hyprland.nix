_: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          text_align = "center"; # center/right or any value for default left. multi-line text alignment inside label container
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 60;
          rotate = 0; # degrees, counter-clockwise

          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Welcome back, $USER!";
          text_align = "center"; # center/right or any value for default left. multi-line text alignment inside label container
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 25;
          rotate = 0; # degrees, counter-clockwise

          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "I have counted $ATTEMPTS failed login attempts.";
          text_align = "center"; # center/right or any value for default left. multi-line text alignment inside label container
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 25;
          rotate = 0; # degrees, counter-clockwise

          position = "0, 40";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          size = "400, 100";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(125, 245, 125)";
          inner_color = "rgb(20, 20, 20)";
          outer_color = "rgb(9, 9, 9)";
          outline_thickness = 5;
          placeholder_text = "Password...";
        }
      ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      monitor = ",highrr,auto,1.875";
      env = [
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_DISABLE_RDD_SANDBOX,1"
        "MOZ_DBUS_REMOTE,1"
        "GTK_THEME,Nordic-darker"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GL_GSYNC_ALLOWED,1"
        "__GL_VRR_ALLOWED,0"
        #"SDL_VIDEODRIVER,wayland"
        "_JAVA_AWT_WM_NONEREPARENTING,1"
        "CLUTTER_BACKEND,wayland"
        "GDK_BACKEND,wayland"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];
      exec-once = [
        "waybar"
        "[ workspace 1 silent ] kitty"
        "[ workspace 2 silent ] firefox"
        "[ workspace 3 silent ] spotify"
        "[ workspace 3 silent ] discord"
        "[ workspace 3 silent ] signal-desktop"
      ];
      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "0xff5a5a5a";
        "col.inactive_border" = "0xff1b1b1b";
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        drop_shadow = false;
        dim_inactive = false;
        dim_strength = 0.1;
        dim_special = 0.3;
        blur = {
          enabled = true;
          new_optimizations = true;
          size = 12;
          vibrancy = 0.3;
          passes = 3;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.21, 0.52, 0.76, 0.46";
        animation = [
          "windows, 1, 0.8, myBezier"
          "windowsOut, 1, 1, default"
          "border, 1, 0.2, default"
          "fade, 1, 0.5, default"
          "workspaces, 1, 2.5, default"
        ];
      };
      dwindle = {
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_touch = true;
        workspace_swipe_touch_invert = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        render_ahead_of_time = false;
        vrr = 2;
      };
      input = {
        kb_options = "caps:escape";
        repeat_rate = 50;
        repeat_delay = 450;
        follow_mouse = 1;

        accel_profile = "adaptive";
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };
      "$mainMod" = "ALT";
      bind = [
        # keybinds"
        "ALT SHIFT,Q,exit,"
        "$mainMod,Q,exec,hyprlock"
        "$mainMod,S,exec,wofi --show drun"
        "$mainMod,RETURN,exec,kitty"
        "$mainMod,G,exec,firefox"
        "$mainMod,N,exec,kitty -e nvim"
        "$mainMod,C,killactive,"

        "$mainMod SHIFT,H,movewindow,l"
        "$mainMod SHIFT,J,movewindow,d"
        "$mainMod SHIFT,K,movewindow,u"
        "$mainMod SHIFT,L,movewindow,r"
        "$mainMod SHIFT,H,movefocus,l"
        "$mainMod SHIFT,J,movefocus,d"
        "$mainMod SHIFT,K,movefocus,u"
        "$mainMod SHIFT,L,movefocus,r"

        "$mainMod,H,movefocus,l"
        "$mainMod,J,movefocus,d"
        "$mainMod,K,movefocus,u"
        "$mainMod,L,movefocus,r"

        "$mainMod,F,fullscreen,"
        "$mainMod,1,workspace,1"
        "$mainMod,2,workspace,2"
        "$mainMod,3,workspace,3"
        "$mainMod,4,workspace,4"
        "$mainMod,5,workspace,5"
        "$mainMod,6,workspace,6"
        "$mainMod,7,workspace,7"
        "$mainMod,8,workspace,8"
        "$mainMod,9,workspace,9"

        "$mainMod SHIFT,1,movetoworkspace,1"
        "$mainMod SHIFT,2,movetoworkspace,2"
        "$mainMod SHIFT,3,movetoworkspace,3"
        "$mainMod SHIFT,4,movetoworkspace,4"
        "$mainMod SHIFT,5,movetoworkspace,5"
        "$mainMod SHIFT,6,movetoworkspace,6"
        "$mainMod SHIFT,7,movetoworkspace,7"
        "$mainMod SHIFT,8,movetoworkspace,8"
        "$mainMod SHIFT,9,movetoworkspace,9"

        "$mainMod,SPACE,togglefloating,"
        "$mainMod,equals,splitratio,+"
        "$mainMod,minus,splitratio,-"
        "$mainMod,P,pseudo,"
        # Scroll through existing workspaces with mainMod + scroll"
        "bind = $mainMod, mouse_down, workspace, e+1"
        "bind = $mainMod, mouse_up, workspace, e-1"

        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioLowerVolume, exec, pulseaudio-ctl down"
        ", XF86AudioRaiseVolume, exec, pulseaudio-ctl up"
        ", XF86AudioMute, exec, pulseaudio-ctl mute"
        ", XF86Calculator, exec, wxmaxima"
        ", Print, exec, wayshot -s \"$(slurp)\" --stdout | wl-copy"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindel = [
        # FN Keybinds
        ", XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight s 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight s +5%"
      ];
    };
  };
}
