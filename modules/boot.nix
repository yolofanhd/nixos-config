{ lib, ... }: {
  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  boot = {
    kernelParams = [
      "intel_pstate=no_hwp"
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    loader.efi.canTouchEfiVariables = true;
    # NOTE: Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    initrd.luks.devices."cryptroot" = {
      preLVM = true;
      allowDiscards = true;
    };

    supportedFilesystems = [ "ntfs" ];
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
}
