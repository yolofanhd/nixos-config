{ lib
, rootDeviceUuid
, ...
}: {
  boot = {
    kernelParams = [
      "intel_pstate=no_hwp"
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    loader.efi.canTouchEfiVariables = true;
    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    initrd.luks.devices."root" = {
      device = "/dev/disk/by-uuid/${rootDeviceUuid}";
      preLVM = true;
      allowDiscards = true;
    };

    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
}
