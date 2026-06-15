{
  programs.waybar = {
    enable = true;
    style = ./sidebar.css;
    settings = {
      sideBar = {
        layer = "top";
        position = "left";
        width = 60;
        output = [
          "eDP-1"
          "HDMI-A-1"
          "DP-1"
        ];
        modules-left = [ "clock" "tray" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "disk" "memory" "cpu" "pulseaudio" "temperature" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
          format-icons = {
            active = "";
            urgent = "";
            default = "";
          };
        };

        "clock" = {
          tooltip = true;
          format = "{:%H\n%M}";
          tooltip-format = "{:%Y-%m-%d}";
        };

        "temperature" = {
          rotate = 90;
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
        };

        "cpu" = {
          interval = 1;
          rotate = 90;
          format = "{icon} {usage}%";
          min-length = 6;
          max-length = 6;
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        };

        "memory" = {
          rotate = 90;
          format = " {percentage}%";
        };

        "disk" = {
          rotate = 90;
          interval = 30;
          format = " {percentage_used}%";
          path = "/";
        };

        "pulseaudio" = {
          rotate = 90;
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "MUTE ";
          format-icons = {
            headphones = "";
            default = [
              ""
              ""
            ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "tray" = {
          icon-size = 18;
          show-passive-items = "true";
        };
      };
    };
  };
}
