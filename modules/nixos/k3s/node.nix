{ config, ... }: {
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = config.age.secrets.kubernetes.path;
    serverAddr = "https://192.168.1.246:6443";
  };
}
