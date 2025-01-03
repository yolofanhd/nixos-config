{ pkgs
, username
, ...
}:
let
  prefix = ./../../modules/home;
in
{
  imports = [
    (prefix + /tmux.nix)
  ];

  home.packages = with pkgs; [
    tmux
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "vim";
    };
    stateVersion = "24.11"; #WARN: Do NOT! edit!!
  };
}
