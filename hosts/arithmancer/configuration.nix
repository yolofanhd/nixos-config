# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config
, lib
, pkgs
, inputs
, username
, ...
}: {
  imports = [
    ./../../modules/wayland.nix
    ./../../modules/sound.nix
    ./../../modules/nvidia.nix
    ./../../modules/yubikey.nix
    ./../../modules/greetd.nix
    ./../../modules/dbus.nix
    ./../../modules/network.nix
    ./../../modules/boot.nix
    ./../../modules/bluetooth.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Temporary fix for yubioauth-flutter not working
  nixpkgs.overlays = [ (final: prev: { flutter = prev.flutter319; }) ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true; # allows unfree packages (spotify, etc.)
  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      tree
      obs-studio
      yubioath-flutter
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
    extraSpecialArgs = { inherit inputs; };
    users = {
      ${username} = import ./home.nix;
    };
  };

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

  security.polkit.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };

  programs.zsh.enable = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };
  security.pam.services.gdm.enableGnomeKeyring = true;
  system.stateVersion = "23.11"; # DO NOT! EDIT!!
}
