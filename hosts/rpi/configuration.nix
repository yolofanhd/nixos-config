{ pkgs
, lib
, inputs
, username
, system
, hostName
, includeHardwareConfig
, isPi5
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
      ]
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
  system.stateVersion = "24.11"; #WARN: Do NOT! edit!!
}
