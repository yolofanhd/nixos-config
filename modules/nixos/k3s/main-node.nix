{ config, ... }: {
  services.k3s = {
    enable = true;
    role = "server";
    token = ''$(cat "${config.age.secrets.kubernetes.path}")'';
    clusterInit = true;
    extraFlags = toString [
      "--debug"
    ];
  };
}
