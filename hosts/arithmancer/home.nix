{ config, pkgs, inputs, system, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fractalix";
  home.homeDirectory = "/home/fractalix";

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x10";
        origin = "top-left";
        transparency = 10;
        frame_color = "#eceff1";
        font = "Droid Sans 9";
      };

      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };

  programs.wofi = {
    enable = true;
    settings = {
      width=300;
height=1410;
location="left";
show="drun";
prompt="Search...";
filter_rate=100;
allow_markup=true;
no_actions=true;
halign="fill";
orientation="vertical";
content_halign="fill";
insensitive=true;
allow_images=true;
image_size=40;
gtk_dark=true;
layer="overlay";
    };
    style = ''
    window {
    margin: 0px;
    border: 2px solid #333;
    background-color: #1b1b1b;
    border-radius: 10px;
    }
    
    #input {
    margin: 5px;
    border: none;
    color: #f8f8f2;
    border-radius: 8px;
    background-color: #2b2b2b;
    }
    
    #inner-box {
    margin: 5px;
    border: none;
    border-radius: 10px;
    background-color: #2b2b2b;
    }
    
    #outer-box {
    margin: 5px;
    border: none;
    border-radius: 10px;
    background-color: #1b1b1b;
    }
    
    #scroll {
    margin: 0px;
    border-radius: 15px;
    border: none;
    }
    
    #text {
      border-radius: 15px;
      margin: 5px;
      border: none;
      color: #f8f8f2;
    } 
    
    #entry.activatable #text {
      color: #282a36;
    }
    
    #entry > * {
      color: #f8f8f2;
    }
    
    #entry:selected {
        border-radius: 2px;
        background-color: #1b441b;
    }
    
    #entry:selected #text {
        border-radius: 2px;
    }
    '';
  };

  programs.waybar = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FantasqueSansM Nerd Font";
      size = 12;
    };
    shellIntegration.enableZshIntegration = true;
    shellIntegration.mode = "no-title no-complete";
    theme = "Gruvbox Dark Hard";
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "vicmd";
    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      share = true;
      size = 10000;
    };
    historySubstringSearch.enable = true;
    prezto = {
      enable = true;
      color = true;
      editor = {
        dotExpansion = true;
	keymap = "vi";
	promptContext = true;
      };
      prompt = {
        pwdLength = "full";
      };
      python = {
        virtualenvAutoSwitch = true;
	virtualenvInitialize = true;
      };
      terminal = {
        autoTitle = true;
      };
      tmux = {
        autoStartLocal = true;
      };
      utility.safeOps = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
	"python"
	"man"
	"colored-man-pages"
	"tmux"
	"zsh-interactive-cd"
	"sudo"
      ];
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "kitty";
    keyMode = "vi";
    newSession = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.sensible;
        extraConfig = "set -g @plugin 'tmux-plugins/tmux-sensible'";
      }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
monitor=,highrr,auto,1
monitor=Unknown-1,disable

env = MOZ_ENABLE_WAYLAND,1
env = MOZ_DISABLE_RDD_SANDBOX,1
env = MOZ_DBUS_REMOTE,1

env = GTK_THEME,Nordic-darker
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
env = QT_QPA_PLATFORM,wayland;xcb
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = QT_QPA_PLATFORMTHEME,qt5ct
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = LIBVA_DRIVER_NAME,nvidia
env = __GL_GSYNC_ALLOWED,1
env = __GL_VRR_ALLOWED,0
#env = SDL_VIDEODRIVER,wayland
env = _JAVA_AWT_WM_NONEREPARENTING,1
env = CLUTTER_BACKEND,wayland
env = GDK_BACKEND,wayland
env = NVD_BACKEND,direct
env = ELECTRON_OZONE_PLATFORM_HINT,auto

exec-once = waybar
#exec-once = ~/.config/hypr/monitor-handler.sh
#exec-once = syncthing
exec-once = swww-daemon
exec-once = swww ~/Pictures/wp-mandelbrot.png

exec-once = [workspace 1 silent] firefox
exec-once = [workspace 1 silent] kitty
exec-once = [workspace 4 silent] spotify --enable-features=UseOzonePlatform --ozone-platform=wayland

input {
    kb_layout=
    kb_variant=
    kb_model=
    kb_rules=
    repeat_rate=50
    repeat_delay=450
    follow_mouse=1

    accel_profile=adaptive
    touchpad {
        natural_scroll=no
    }
    sensitivity = 0
}

general {
    gaps_in=4
    gaps_out=8
    border_size=2
    col.active_border=0xff5a5a5a
    col.inactive_border=0xff1b1b1b
    layout=dwindle
}

decoration {
    rounding=10
    drop_shadow=no
    dim_inactive=false
    dim_strength=0.1
    dim_special=0.3
    blur {
      enabled=true
      new_optimizations=true
      size=12
      vibrancy=0.3
      passes=3
    }
}

animations {
    enabled=yes
    bezier = myBezier, 0.21, 0.52, 0.76, 0.46

    animation = windows, 1, 0.8, myBezier
    animation = windowsOut, 1, 1, default
    animation = border, 1, 0.2, default
    animation = fade, 1, 0.5, default
    animation = workspaces, 1, 2.5, default
}

dwindle {
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    new_is_master = true
}

gestures {
    workspace_swipe=on
}

misc {
    disable_hyprland_logo=true
    disable_splash_rendering=true
    render_ahead_of_time=false
    no_direct_scanout=true
    vrr=2
}

# example window rules
# for windows named/classed as abc and xyz
#windowrule=move 69 420,abc
#windowrule=size 420 69,abc
#windowrule=tile,xyz
#windowrule=pseudo,abc
#windowrule=monitor 0,xyz
windowrule=move 20 20,^(galculator)$
windowrule=float,^(galculator)$
windowrule=workspace 4, ^(spotify)$

$mainMod = ALT

# keybinds
bind=ALT SHIFT,Q,exit,
bind=$mainMod,Q,exec,waylock -init-color 0x1b1b1b -input-color 0x1b1f1b -fail-color 0x1f1b1b

bind=$mainMod,S,exec,wofi --show drun
bind=$mainMod,RETURN,exec,kitty
bind=$mainMod,G,exec,firefox
bind=$mainMod,N,exec,alacritty -e nvim

bind=$mainMod,C,killactive,

bind=$mainMod SHIFT,H,movewindow,l
bind=$mainMod SHIFT,J,movewindow,d # char 246 = ö
bind=$mainMod SHIFT,K,movewindow,u
bind=$mainMod SHIFT,L,movewindow,r

bind=$mainMod SHIFT,H,movefocus,l
bind=$mainMod SHIFT,J,movefocus,d
bind=$mainMod SHIFT,K,movefocus,u
bind=$mainMod SHIFT,L,movefocus,r

bind=$mainMod,H,movefocus,l
bind=$mainMod,J,movefocus,d
bind=$mainMod,K,movefocus,u
bind=$mainMod,L,movefocus,r

bind=$mainMod,F,fullscreen,

bind=$mainMod,1,workspace,1
bind=$mainMod,2,workspace,2
bind=$mainMod,3,workspace,3
bind=$mainMod,4,workspace,4
bind=$mainMod,5,workspace,5
bind=$mainMod,6,workspace,6
bind=$mainMod,7,workspace,7
bind=$mainMod,8,workspace,8
bind=$mainMod,9,workspace,9

bind=$mainMod SHIFT,1,movetoworkspace,1
bind=$mainMod SHIFT,2,movetoworkspace,2
bind=$mainMod SHIFT,3,movetoworkspace,3
bind=$mainMod SHIFT,4,movetoworkspace,4
bind=$mainMod SHIFT,5,movetoworkspace,5
bind=$mainMod SHIFT,6,movetoworkspace,6
bind=$mainMod SHIFT,7,movetoworkspace,7
bind=$mainMod SHIFT,8,movetoworkspace,8
bind=$mainMod SHIFT,9,movetoworkspace,9

bind=$mainMod,page_up,workspace,e+1
bind=$mainMod,page_down,workspace,e-1

bind=$mainMod,SPACE,togglefloating,

bind=$mainMod,equals,splitratio,+
bind=$mainMod,minus,splitratio,-

bind=$mainMod,P,pseudo,

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# FN Keybinds

bindel = , XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight s 5%-
bindel = , XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight s +5%

bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous

bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5.0%-
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5.0%+
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

bind = , XF86Calculator, exec, wxmaxima
bind = $mainMod SHIFT, P, exec, wayshot -s "$(slurp)" --stdout | wl-copy
    '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[
    kitty
    zsh
    tmux
    
    git

    firefox # browser
    spotify 
    obsidian # note taking app
    
    cheat
    swww # background images

    wl-clipboard
    slurp # for screenshotting in wayland cli tool
    wayshot # for screenshotting in wayland cli tool

    anki-bin # learning cards
    texlive.combined.scheme-full # latex support

    zathura # pdf reader
    
    cura # ultimaker cura 3d printer 
    steam

    inputs.myvim.packages."x86_64-linux".default

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fractalix/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
