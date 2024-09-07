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
    (modulePrefix + /boot.nix)
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      inputs.zen-browser.packages.${system}.default
      firefox
      obs-studio
      yubioath-flutter
      waybar
      signal-desktop
      gimp
      blender
      vscodium
      docker
      bitwarden
      xplorer
      discord
      ungoogled-chromium
      vimPlugins.coc-clangd
    ];
  };

  environment.systemPackages = with pkgs; [
    htop
    btop
    sbctl # For secureboot debugging stuff
    unzip
    tree
    zip
    vim
    wget
    cmake
    polkit
    polkit_gnome
    docker
    gcc
    pinentry-curses
    python3
  ];

  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    polkit.enable = true;
    pam = {
      services.gdm.enableGnomeKeyring = true;
      services = {
        hyprlock = { };
      };
    };
  };

  programs.zsh.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
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

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11"; #WARN: DO NOT! EDIT!!
}
