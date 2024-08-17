# This package holds a few configurations for dbus
{ config, lib, pkgs, inputs, ... }:

{
  services.dbus.enable = true;

  services.dbus.packages = with pkgs; [dconf];
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  environment = {
     loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
    '';
  };
}
