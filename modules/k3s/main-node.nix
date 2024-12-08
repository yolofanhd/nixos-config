{
  services.k3s = {
    enable = true;
    role = "server";
    token = "test";
    clusterInit = true;
    extraFlags = toString [
      "--debug"
    ];
  };
}
