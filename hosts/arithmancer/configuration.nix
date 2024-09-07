{ pkgs
, inputs
, username
, system
, ...
}:
let
  rootPrefix = ./../..;
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
    (modulePrefix + /nix-defaults.nix)
    (rootPrefix + /hardware-configuration.nix)
    inputs.home-manager.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    btop
    cmake
    docker
    gcc
    git
    htop
    pinentry-curses
    polkit
    polkit_gnome
    python3
    sbctl
    tree
    unzip
    vim
    wget
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      anki-bin
      bitwarden
      blender
      cheat
      discord
      docker
      firefox
      gimp
      inputs.zen-browser.packages.${system}.default
      obs-studio
      obsidian # note taking app
      signal-desktop
      slurp # for screenshotting in wayland cli tool
      spotify
      steam
      swww # background images
      texlive.combined.scheme-full
      ungoogled-chromium
      vimPlugins.coc-clangd
      vscodium
      waybar
      wayshot # for screenshotting in wayland cli tool
      wl-clipboard
      xplorer
      yubioath-flutter
      zathura # pdf reader
      zip
    ];
  };

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
