{
  nixpkgs = {
    config.allowUnfree = true;
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
