{ pkgs
, inputs
, username
, system
, hostname
, ...
}:
let
  modulePrefix = ./../../modules;
in
{
  imports = [
    # Include the results of the hardware scan.)
    (modulePrefix + /wayland.nix)
    (modulePrefix + /sound.nix)
    (modulePrefix + /nvidia.nix)
    (modulePrefix + /yubikey.nix)
    (modulePrefix + /greetd.nix)
    (modulePrefix + /dbus.nix)
    (modulePrefix + /network.nix)
    (modulePrefix + /bluetooth.nix)
    (modulePrefix + /systemd.nix)
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  services.fprintd.enable = true;
  services.fprintd.tod = {
    enable = true;
    driver = pkgs.libfprint-2-tod1-vfs0090;
    #driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  };

  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/etc/secureboot";
    # };
    loader = {
      systemd-boot = {
        # Lanzaboote currently replaces the systemd-boot module.
        # This setting is usually set to true in configuration.nix
        # generated at installation time. So we force it to false
        # for now.
        #enable = lib.mkForce false;
        enable = true;
        consoleMode = "auto";
      };
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
  };
  time.timeZone = "Europe/Vienna";

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "${hostname}";

  i18n.defaultLocale = "en_US.UTF-8";

  # services.printing.enable = true; # enables cups for printing service

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  security = {
    # tpm2 = {
    #   enable = true;
    #   pkcs11.enable = true;
    #   tctiEnvironment.enable = true;
    # };
    polkit.enable = true;
    pam = {
      services.gdm.enableGnomeKeyring = true;
      u2f = {
        enable = true;
        cue = true;
        control = "sufficient";
      };
      services = {
        greetd.u2fAuth = true;
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        hyprlock = { };
      };
    };
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    sbctl # For secureboot debugging stuff
    vim
    wget
    cmake
    polkit
    polkit_gnome
    docker
    gcc
    pinentry-curses
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "tss" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      tree
      obs-studio
      yubioath-flutter
      wofi
      waybar
      signal-desktop
      unzip
      zip
      htop
      gimp
      blender
      vscodium
      docker
      bitwarden
      xplorer
      discord
      cinny-desktop
      ungoogled-chromium
      vimPlugins.coc-clangd
    ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit username;
      inherit system;
    };
    backupFileExtension = "backup";
    users = {
      ${username} = import ./home.nix;
    };
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    config.allowUnfree = true; # allows unfree packages (spotify, etc.)
    overlays = [
<<<<<<< HEAD
      (final: prev: { flutter = prev.flutter319; }) # Temporary flutter patch TODO: Remove when fixed
=======
      #TODO: Remove temporary fixes when resolved
      (_final: prev: { flutter = prev.flutter319; }) #INFO: Temporary flutter patch
>>>>>>> 2dcccb3 (chore: created .gitignore and removed possible private data)
    ];
  };

  system.stateVersion = "23.11"; #INFO: DO NOT! EDIT!!
}
