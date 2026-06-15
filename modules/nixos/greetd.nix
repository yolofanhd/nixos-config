{ username, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "${username}";
      };
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
