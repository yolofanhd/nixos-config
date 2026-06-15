{ ... }:
let
  desktops = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
  ];

  desktopBindings = builtins.concatStringsSep "\n" (
    map
      (desktop: ''
        cmd - ${desktop} : yabai -m space --focus ${desktop}
        cmd + shift - ${desktop} : yabai -m window --space ${desktop}; yabai -m space --focus ${desktop}
      '')
      desktops
  );
in
{
  services.yabai = {
    enable = true;
    enableScriptingAddition = false;

    config = {
      layout = "bsp";
      window_placement = "second_child";
      window_topmost = "off";
      window_shadow = "on";
      window_opacity = "off";
      window_border = "off";
      split_ratio = "0.50";
      auto_balance = "off";
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      top_padding = 8;
      bottom_padding = 8;
      left_padding = 8;
      right_padding = 8;
      window_gap = 4;
    };

    extraConfig = ''
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add title="Picture-in-Picture" manage=off sticky=on
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd - return : open -na kitty --args -e tmux

      cmd - h : yabai -m window --focus west
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north
      cmd - l : yabai -m window --focus east

      cmd + shift - h : yabai -m window --warp west
      cmd + shift - j : yabai -m window --warp south
      cmd + shift - k : yabai -m window --warp north
      cmd + shift - l : yabai -m window --warp east

      cmd - f : yabai -m window --toggle zoom-fullscreen
      cmd - p : yabai -m window --toggle split
      cmd - 0x2A : yabai -m window --toggle float

      cmd - 0x18 : yabai -m window --resize right:50:0 || yabai -m window --resize left:50:0
      cmd - 0x1B : yabai -m window --resize right:-50:0 || yabai -m window --resize left:-50:0

      ${desktopBindings}
    '';
  };
}
