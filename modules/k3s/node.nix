{ config, ... }: {
  services.k3s = {
    enable = true;
    role = "agent";
    token = ''$(cat "${config.age.secrets.kubernetes.path}")'';
    serverAddr = "https://192.168.1.246:6443";
  };
}
