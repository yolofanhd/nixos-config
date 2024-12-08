{ pkgs
, lib
, inputs
, username
, system
, hostName
, includeHardwareConfig
, isPi5
, isNotMain
, ...
}:
let
  rootPrefix = ./../..;
  modulePrefix = ./../../modules;
in
{
  imports =
    lib.optionals includeHardwareConfig
      [
        (rootPrefix + /hardware-configuration.nix)
      ]
    ++ lib.optionals isPi5
      [
        ./pi5.nix
        (modulePrefix + /k3s/main-node.nix)
      ]
    ++ lib.optionals isNotMain
      [
        (modulePrefix + /k3s/node.nix)
      ]
    ++ [
      (modulePrefix + /nix-defaults.nix)
      (modulePrefix + /agenix.nix)
      inputs.home-manager.nixosModules.default
    ];
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    btop
    wget
    libraspberrypi
    raspberrypi-eeprom
    inputs.agenix.packages.${system}.default
  ];

  users = {
    users.pi = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  boot = {
    kernelParams = [
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
    ];

    loader = {
      systemd-boot.enable = true;
      generic-extlinux-compatible.enable = false;
      efi.canTouchEfiVariables = false;
    };
  };
  networking = {
    inherit hostName;
    networkmanager.enable = true;
    firewall = {
      enable = lib.mkForce false;
      allowedTCPPorts = [
        6443
        2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
        2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
      ];
      allowedUDPPorts = [
        8472
      ];
    };
    wireless = {
      enable = false;
    };
  };

  boot.kernelModules = [
    "br_netfilter"
    "ip_conntrack"
    "ip_vs"
    "ip_vs_rr"
    "ip_vs_wrr"
    "ip_vs_sh"
    "overlay"
  ];

  boot.kernel.sysctl = {
    "net.bridge-nf-call-ip6tables" = 1;
    "net.bridge-nf-call-iptables" = 1;
    "net.ipv4.ip_forward" = 1;
  };

  time.timeZone = "Europe/Vienna";
  home-manager = {
    extraSpecialArgs = {
      inherit username;
      inherit inputs;
      inherit system;
    };
    users = {
      ${username} = import ./home.nix;
    };
  };
  services.openssh.enable = true;
  system.stateVersion = "24.11"; #WARN: Do NOT! edit!!
}
