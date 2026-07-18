{ config, ... }: {
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.age.secrets.kubernetes.path;
    clusterInit = true;
    extraFlags = toString [
      "--debug"
    ];
  };
}
