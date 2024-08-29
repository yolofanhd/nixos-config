{ pkgs
, inputs
, username
, system
, hostName
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    kernelPackages = inputs.rpi5-flake.legacyPackages.aarch64-linux.linuxPackages_rpi5;
  };

  networking = {
    networkmanager.enable = true;
    inherit hostName;
    wireless = {
      enable = false;
      userControlled = {
        enable = true;
        group = "network";
      };
    };
  };

  time.timeZone = "Europe/Vienna";

  users = {
    groups.networking = { };
    users.pi = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networking" ];
      packages = with pkgs; [
      ];
    };
  };

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

  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    btop
    wget
    inputs.myvim.packages."${system}".default
  ];

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "24.11"; #WARN: Do NOT! edit!!
}
