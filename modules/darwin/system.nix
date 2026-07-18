{ pkgs
, ...
}:
{
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

  system.defaults = {
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
}
