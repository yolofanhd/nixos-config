{ hostName, ... }: {
  networking = {
    inherit hostName;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 5900 ]; # For streaming a headless monitor via vnc
      allowedUDPPorts = [ 5900 ];
    };
  };
}
