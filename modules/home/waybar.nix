{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    style = ./waybar.css;
    settings = {
      topBar = {
        id = "topbar";
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
          "HDMI-A-1"
          "DP-1"
        ];
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "mpd" "backlight" "wireplumber" "bluetooth" "temperature" "battery" "tray" ];

        "hyprland/workspaces" = { };
        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      };
      sideBar = {
        id = "sidebar";
        layer = "top";
        position = "left";
        width = 30;
        output = [
          "eDP-1"
          "HDMI-A-1"
          "DP-1"
        ];
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "mpd" "backlight" "wireplumber" "bluetooth" "temperature" "battery" "tray" ];

        "hyprland/workspaces" = { };
        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      };
    };
  };
}
