{ hostName, ... }: {
  networking = {
    inherit hostName;
    networkmanager.enable = true;
    # firewall.enable = true;
  };
}
