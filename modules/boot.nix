
{ config, lib, pkgs, inputs, ... }:

{
  boot.kernelParams = [ 
    "intel_pstate=no_hwp" 
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];
  

  # Boot loader configuration

  boot.loader.efi.canTouchEfiVariables = true;
  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  #security.tpm2.enable = true;
  #security.tpm2.pkcs11.enable = true;
  #security.tpm2.tctiEnvironment.enable = true;

  #boot.loader.systemd-boot = {
  #  enable = true;
  #  consoleMode = "auto";
  #};

  #boot.loader.grub = {
  #  enable = true;
  #  device = "nodev";
  #  efiSupport = true;
  #  useOSProber = true;
  #  gfxmodeEfi = "1024x768";
  #};
  
  # File system configuration

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  # Used for full disk encryption
  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/65eec619-2d7c-45e3-b905-898f4ee59be8";
    preLVM = true;
    allowDiscards = true;
  };

  boot.kernelModules = [
     "nvidia"
     "nvidia_modeset"
     "nvidia_uvm"
     "nvidia_drm"
  ];
}
