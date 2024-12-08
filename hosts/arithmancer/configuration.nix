{ pkgs
, inputs
, includeHardwareConfig
, username
, system
, lib
, ...
}:
let
  rootPrefix = ./../..;
  modulePrefix = rootPrefix + /modules;
in
{
  imports =
    lib.optionals includeHardwareConfig
      [
        (rootPrefix + /hardware-configuration.nix)
        (modulePrefix + /boot.nix)
      ]
    ++ [
      (modulePrefix + /agenix.nix)
      (modulePrefix + /wayland.nix)
      (modulePrefix + /sound.nix)
      (modulePrefix + /nvidia.nix)
      (modulePrefix + /yubikey.nix)
      (modulePrefix + /greetd.nix)
      (modulePrefix + /dbus.nix)
      (modulePrefix + /network.nix)
      (modulePrefix + /bluetooth.nix)
      (modulePrefix + /systemd.nix)
      (modulePrefix + /nix-defaults.nix)
      (modulePrefix + /gnupg.nix)
      inputs.home-manager.nixosModules.default
    ];

  fonts.packages = with pkgs; [
    nerd-fonts.fantasque-sans-mono
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
    inputs.agenix.packages.${system}.default
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    initialPassword = "nixos";
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

  services.openssh.enable = true;

  programs.zsh.enable = true;

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11"; #WARN: DO NOT! EDIT!!
}
