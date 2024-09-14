{
  security = {
    polkit.enable = true;
    pam = {
      services.gdm.enableGnomeKeyring = true;
      u2f = {
        enable = true;
        settings.cue = true;
        control = "sufficient";
      };
      services = {
        greetd.u2fAuth = true;
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        hyprlock = { };
      };
    };
  };
  services.pcscd.enable = true;
}
