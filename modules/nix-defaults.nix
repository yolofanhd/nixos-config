# Default nix config with some garbage collect for images older than a week
_: {
  nixpkgs = {
    config.allowUnfree = true; # allows unfree packages (spotify, etc.)
    overlays = [
    ];
  };
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
