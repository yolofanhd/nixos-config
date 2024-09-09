{ username, ... }: {
  networking = {
    firewall = {
      allowedUDPPorts = [ 51820 ];
      checkReversePath = false;
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "192.168.2.2/24" ];
        dns = [ "192.168.2.1" ];
        listenPort = 51820;
        privateKeyFile = "/home/${username}/.wireguard/privatekey";
        peers = [
          {
            publicKey = "GM651G9yCtOjeu020TYSyoqY5rMwe2iebW7i8m6sFko=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "130.162.247.77:60477";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
