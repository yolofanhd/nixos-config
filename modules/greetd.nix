# This config holds stuff about greetd
{ config
, lib
, pkgs
, inputs
, username
, ...
}: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "${username}";
      };
      default_session = initial_session;
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StadardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
