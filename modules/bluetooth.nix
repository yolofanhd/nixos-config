{ config, lib, pkgs, inputs, username, ... }:

{
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
