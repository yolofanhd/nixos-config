{ hostName, ... }: {
  networking = {
    inherit hostName;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ 51820 8000 ];
      allowedTCPPorts = [ 51820 8000 ];
    };

    #wireguard.interfaces = {
    #  wg0 = {
    #    ips = [ "10.100.0.2/24" ];
    #    listenPort = 51820;
    #    privateKeyFile = "/home/fractalix/.wireguard/privatekey";

    #    peers = [
    #      {
    #        publicKey = "sA4ZS0+tufXZeR+n+XOhq47AC4n6gGNhGeDFCXajCFE=";
    #        allowedIPs = [ "0.0.0.0/0" ];
    #        # Or forward only particular subnets
    #        #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

    #        endpoint = "{server ip}:51820";
    #        persistentKeepalive = 25;
    #      }
    #    ];
    #  };
    #};
  };
}
