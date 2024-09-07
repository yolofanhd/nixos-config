{ pkgs, ... }: {
  services.dbus = {
    enable = true;
    packages = with pkgs; [ dconf ];
  };
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  environment = {
    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
    '';
  };
}
