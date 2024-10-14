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
    lib.optionals includeHardwareConfig
      [
        (rootPrefix + /hardware-configuration.nix)
      ]
    ++ [
      (modulePrefix + /nix-defaults.nix)
    ];

  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    btop
    wget
    libraspberrypi
    raspberrypi-eeprom
  ];

  users = {
    users.pi = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
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

  system.stateVersion = "24.11"; # Did you read the comment?
}

