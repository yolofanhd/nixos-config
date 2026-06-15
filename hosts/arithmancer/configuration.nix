{
  pkgs,
  inputs,
  lib,
  username,
  system,
  config,
  includeHardwareConfig,
  ...
}:
let
  rootPrefix = ./../..;
  modulePrefix = rootPrefix + /modules;
in
{
  imports =
    lib.optionals includeHardwareConfig [
      (rootPrefix + /hardware-configuration.nix)
      (modulePrefix + /nixos/boot.nix)
    ]
    ++ [
      (modulePrefix + /nixos/agenix.nix)
      (modulePrefix + /nixos/wayland.nix)
      (modulePrefix + /nixos/sound.nix)
      (modulePrefix + /nixos/nvidia.nix)
      (modulePrefix + /nixos/yubikey.nix)
      (modulePrefix + /nixos/greetd.nix)
      (modulePrefix + /nixos/dbus.nix)
      (modulePrefix + /nixos/network.nix)
      (modulePrefix + /nixos/bluetooth.nix)
      (modulePrefix + /nixos/systemd.nix)
      (modulePrefix + /nixos/nix-defaults.nix)
      (modulePrefix + /nixos/gnupg.nix)
      inputs.home-manager.nixosModules.default
    ];

  fonts.packages = with pkgs; [
    nerd-fonts.fantasque-sans-mono
  ];

  environment = {
    shells = [ pkgs.zsh ];
    systemPackages = with pkgs; [
      btop
      prusa-slicer
      cmake
      docker
      gcc
      clang
      ghostscript
      git
      htop
      mermaid-cli
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
      inputs.pwndbg.packages.${system}.default
    ];
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.${username} = {
      isNormalUser = true;
      useDefaultShell = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      initialPassword = "nixos";
      packages = with pkgs; [
        anki-bin
        #bitwarden
        blender
        cheat
        discord
        docker
        gimp
        inputs.zen-browser.packages.${system}.default
        just
        obs-studio
        obsidian # note taking app
        signal-desktop
        slurp # for screenshotting in wayland cli tool
        spotify
        steam
        swww # background images
        texlive.combined.scheme-full
        google-chrome
        vscodium
        inputs.waybar.packages.${system}.default
        wayvnc
        wayshot # for screenshotting in wayland cli tool
        wl-clipboard
        yubioath-flutter
        zathura # pdf reader
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
      inherit (config) age;
    };
    backupFileExtension = "backup";
    users = {
      ${username} = import ./home.nix;
    };
  };

  services.openssh.enable = true;
  programs.steam.enable = true;
  programs.zsh.enable = true; # INFO: system-wide needed in addition to home-manager

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11"; # WARN: DO NOT! EDIT!!
}
