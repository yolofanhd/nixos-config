# Fingerprint service related config
# NOTE: Currently not in use due to unsupported hardware
{ pkgs, ... }: {
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
      #driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
    };
  };
}
