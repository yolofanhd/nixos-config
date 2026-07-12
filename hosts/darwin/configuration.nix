{
  lib,
  pkgs,
  inputs,
  config,
  username,
  system,
  hostName,
  ...
}:
let
  rootPrefix = ./../..;
  modulePrefix = rootPrefix + /modules;

  prusaSlicer = pkgs.stdenvNoCC.mkDerivation {
    pname = "PrusaSlicer";
    version = "2.9.5";

    src = pkgs.fetchurl {
      url = "https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.9.5/PrusaSlicer-2.9.5.dmg";
      hash = "sha256-53Bf9e7zFNToayUAhuJLp+w7KNJHIy5F4hFCDDGlcA8=";
    };

    nativeBuildInputs = [ pkgs.undmg ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      cp -R "Original Prusa Drivers/PrusaSlicer.app" "$out/Applications/"

      runHook postInstall
    '';

    meta = {
      description = "G-code generator for 3D printers";
      homepage = "https://github.com/prusa3d/PrusaSlicer";
      license = pkgs.lib.licenses.agpl3Only;
      platforms = pkgs.lib.platforms.darwin;
      mainProgram = "PrusaSlicer";
    };
  };
in
{
  imports = [
    (modulePrefix + /darwin/agenix.nix)
    (modulePrefix + /darwin/yabai.nix)
  ];

  networking.hostName = hostName;

  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  system.checks.text = lib.mkForce "";
  system.activationScripts.applications.text = lib.mkForce "";

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  environment = {
    shells = [ pkgs.zsh ];
    systemPackages = with pkgs; [
      btop
      inputs.nixpkgs-stable.legacyPackages.${system}.blender
      docker
      cmake
      gcc
      clang
      python3
      nodejs
      uv
      ruff
      unzip
      git
      just
      kitty
      nil
      nixd
      prusaSlicer
      tree
      vim
      ripgrep
      fd
      bat
      delta
      fzf
      jq
      eza
      yq
      ast-grep
      nix-tree
      nix-index
      wget
      inputs.agenix.packages.${system}.default
      inputs.codex-cli-nix.packages.${system}.default
      inputs.nixpkgs-zed.legacyPackages.${system}.zed-editor
      spotify
      discord
      inputs.zen-browser.packages.${system}.default
    ];
  };

  programs.zsh.enable = true;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
    packages = with pkgs; [
      docker
    ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs modulePrefix system username;
      inherit (config) age;
    };
    backupFileExtension = "backup";
    users.${username} = import ./home.nix;
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        NSAutomaticWindowAnimationsEnabled = false;
        NSScrollAnimationEnabled = false;
        NSWindowResizeTime = 0.001;
      };

      dock = {
        expose-animation-duration = 0.03;
        launchanim = false;
        slow-motion-allowed = false;
      };
    };

    primaryUser = username;
    stateVersion = 6;
  };
}
