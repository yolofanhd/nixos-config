{ pkgs
, inputs
, username
, system
, ...
}:
let
  modulePrefix = ./../../modules;
in
{
  imports = [
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

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
      #driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
    };
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

  i18n.defaultLocale = "en_US.UTF-8";

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
        settings.cue = true;
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
    btop
    cheat
    cmake
    docker
    htop
    gcc
    git
    polkit
    polkit_gnome
    pinentry-curses
    sbctl # For secureboot debugging stuff
    texlive.combined.scheme-full
    tree
    vim
    vimPlugins.coc-clangd
    wget
    (pkgs.nerdfonts.override {
      fonts = [ "FantasqueSansMono" ];
    })
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "tss" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      anki-bin
      bitwarden
      brightnessctl
      blender
      discord
      docker
      firefox
      gimp
      inputs.myvim.packages.${system}.default
      obs-studio
      obsidian
      signal-desktop
      spotify
      ungoogled-chromium
      unzip
      vscodium
      waybar
      wofi
      xplorer
      yubioath-flutter
      inputs.zen-browser.packages.${system}.default
      zathura
      zip
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
    ];
  };

  system.stateVersion = "23.11"; #WARN: DO NOT! EDIT!!
}
