{
  services.k3s = {
    enable = true;
    role = "agent";
    token = "test";
    serverAddr = "https://192.168.1.246:6443";
  };
}
