{ pkgs
, inputs
, lib
, username
, system
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

  environment.systemPackages = with pkgs; [
    btop
    cmake
    docker
    gcc
    git
    htop
    nerd-fonts.fantasque-sans-mono
    pinentry-curses
    polkit
    polkit_gnome
    sbctl
    texlive.combined.scheme-full
    tree
    vim
    vimPlugins.coc-clangd
    wget
    inputs.agenix.packages.${system}.default
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
      cheat
      discord
      docker
      element-desktop
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
      inherit modulePrefix;
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
  system.stateVersion = "24.11"; # WARN: DO NOT! EDIT!!
}
