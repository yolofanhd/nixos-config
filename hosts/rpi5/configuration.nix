{ pkgs
, lib
, inputs
, username
, system
, hostName
, includeHardwareConfig
, ...
}:
let
  rootPrefix = ./../..;
  modulePrefix = ./../../modules;
in
{
  imports =
    lib.optional includeHardwareConfig (rootPrefix + /hardware-configuration.nix)
    ++ [
      (modulePrefix + /nix-defaults.nix)
      inputs.home-manager.nixosModules.default
    ];

  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    btop
    wget
    inputs.myvim.packages."${system}".default
  ];

  users = {
    users.pi = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
      ];
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    kernelPackages = inputs.rpi5-flake.legacyPackages.aarch64-linux.linuxPackages_rpi5;
  };

  networking = {
    inherit hostName;
    networkmanager.enable = true;
    firewall.enable = false;
    wireless = {
      enable = false;
    };
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
