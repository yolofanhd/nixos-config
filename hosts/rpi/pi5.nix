{ inputs, ... }: {
  boot.kernelPackages = inputs.rpi5-flake.legacyPackages.aarch64-linux.linuxPackages_rpi5;
  boot.loader.systemd-boot.enable = true;
}
