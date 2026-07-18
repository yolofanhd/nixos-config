{ pkgs
, inputs
, config
, username
, system
, hostName
, ...
}:
let
  rootPrefix = ./../..;
  modulePrefix = rootPrefix + /modules;
in
{
  imports = [
    (modulePrefix + /darwin/agenix.nix)
    (modulePrefix + /darwin/packages.nix)
    (modulePrefix + /darwin/system.nix)
    (modulePrefix + /darwin/yabai.nix)
  ];

  networking.hostName = hostName;

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
