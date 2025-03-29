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

  environment = {
    shells = [ pkgs.zsh ];
    systemPackages = with pkgs; [
      btop
      cmake
      docker
      gcc
      git
      htop
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
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.${username} = {
      isNormalUser = true;
      useDefaultShell = true;
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
        steam
        swww # background images
        ungoogled-chromium
        unzip
        vscodium
        waybar
        wayshot # for screenshotting in wayland cli tool
        wayvnc
        wl-clipboard
        wofi
        xplorer
        yubioath-flutter
        inputs.zen-browser.packages.${system}.default
        zathura
        zip
      ];
    };
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
  programs.steam.enable = true;
  programs.zsh.enable = true; # system-wide needed in addition to home-manager

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11"; #WARN: DO NOT! EDIT!!
}
