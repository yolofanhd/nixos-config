{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [inputs.nixpkgs-wayland.overlay];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };  
}
