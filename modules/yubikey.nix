# This config holds Yubikey related stuff
_: {
  security.pam.u2f = {
    enable = true;
    settings.cue = true;
    control = "sufficient";
  };
  security.pam.services = {
    greetd.u2fAuth = true;
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  services.pcscd.enable = true;
}
