{
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
in
{
  imports = [
    (modulePrefix + /darwin/agenix.nix)
    (modulePrefix + /darwin/yabai.nix)
  ];

  networking.hostName = hostName;

  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  environment = {
    shells = [ pkgs.zsh ];
    systemPackages = with pkgs; [
      btop
      docker
      cmake
      gcc
      clang
      python3
      uv
      unzip
      git
      just
      kitty
      tree
      vim
      wget
      inputs.agenix.packages.${system}.default
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
    primaryUser = username;
    stateVersion = 6;
  };
}
