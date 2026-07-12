{
  programs.kitty = {
    enable = true;
    font = {
      name = "FantasqueSansM Nerd Font";
      size = 14;
    };
    shellIntegration.enableZshIntegration = true;
    shellIntegration.mode = "no-title no-complete";
    settings = {
      hide_window_decorations = "titlebar-only";
      macos_titlebar_color = "background";
      window_padding_width = 6;
    };
    themeFile = "GruvboxMaterialDarkHard";
  };
}
