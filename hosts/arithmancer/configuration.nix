{ pkgs
, inputs
, lib
, username
, system
, config
, hardwareConfig
, ...
}:
let
  rootPrefix = ./../..;
  modulePrefix = rootPrefix + /modules;
  packageModule = {
    fonts.packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
    ];

    environment = {
      shells = [ pkgs.zsh ];
      systemPackages = with pkgs; [
        btop
        clang
        cmake
        docker
        gcc
        ghostscript
        git
        htop
        inputs.agenix.packages.${system}.default
        inputs.pwndbg.packages.${system}.default
        mermaid-cli
        pinentry-curses
        polkit
        polkit_gnome
        prusa-slicer
        python3
        sbctl
        tree
        unzip
        vim
        wget
      ];
    };

    users.users.${username}.packages = with pkgs; [
      anki-bin
      blender
      cheat
      discord
      docker
      gimp
      google-chrome
      inputs.waybar.packages.${system}.default
      inputs.zen-browser.packages.${system}.default
      just
      obs-studio
      obsidian
      signal-desktop
      slurp
      spotify
      steam
      inputs.nixpkgs.legacyPackages.${system}.awww
      texliveFull
      vscodium
      wayvnc
      wayshot
      wl-clipboard
      yubioath-flutter
      zathura
      zip
    ];
  };
in
{
  imports =
    lib.optionals (hardwareConfig != null) [
      hardwareConfig
      (modulePrefix + /nixos/boot.nix)
    ]
    ++ lib.optional (hardwareConfig == null) {
      # Pure evaluation has no machine-specific filesystems or boot loader.
      boot.isContainer = true;
    }
    ++ [
      packageModule
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

  users = {
    defaultUserShell = pkgs.zsh;
    users.${username} = {
      isNormalUser = true;
      useDefaultShell = true;
      extraGroups = [
        "wheel"
        "docker"
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
