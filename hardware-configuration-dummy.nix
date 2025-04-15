{ lib
, modulesPath
, ...
}: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "/dev/null";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/null";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  boot.initrd.luks.devices."cryptroot".device = "/dev/null";
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
