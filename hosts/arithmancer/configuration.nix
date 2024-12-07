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

  hardware.opengl.driSupport32Bit = true;

  # configuration.nix

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.nvidia.powerManagement.enable = true;

  # Making sure to use the proprietary drivers until the issue above is fixed upstream
  hardware.nvidia.open = false;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  environment.systemPackages = with pkgs; [
    prusa-slicer
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
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    (
      let
        cura5 = appimageTools.wrapType2 rec {
          name = "cura5";
          version = "5.4.0";
          src = fetchurl {
            url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-modern.AppImage";
            hash = "sha256-QVv7Wkfo082PH6n6rpsB79st2xK2+Np9ivBg/PYZd74=";
          };
          extraPkgs = pkgs: with pkgs; [ ];
        };
      in
      writeScriptBin "cura" ''
        #! ${pkgs.bash}/bin/bash
        # AppImage version of Cura loses current working directory and treats all paths relateive to $HOME.
        # So we convert each of the files passed as argument to an absolute path.
        # This fixes use cases like `cd /path/to/my/files; cura mymodel.stl anothermodel.stl`.
        args=()
        for a in "$@"; do
          if [ -e "$a" ]; then
            a="$(realpath "$a")"
          fi
          args+=("$a")
        done
        exec "${cura5}/bin/cura5" "''${args[@]}"
      ''
    )
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    initialPassword = "nixos";
    packages = with pkgs; [
      anki-bin
      #bitwarden
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
