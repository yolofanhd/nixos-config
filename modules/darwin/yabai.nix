{ pkgs, ... }:
let
  yabaiFork = pkgs.yabai.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "agg23";
      repo = "yabai";
      rev = "d0d387d1445048415fd1f3566393a191fe3c5097";
      hash = "sha256-6tNi20q8K4LeNETjFA5nEDqcSVSBYvRFbzcJbDx7ntA=";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.llvmPackages.lld ];

    postPatch = oldAttrs.postPatch + ''
      substituteInPlace makefile \
        --replace-fail 'clang -isystem' 'clang -fuse-ld=lld -isystem'
      substituteInPlace src/space_manager.c \
        --replace-fail \
          'CGEventSetDoubleValueField(ev, 124, -sign);' \
          'CGEventSetDoubleValueField(ev, 124, sign);' \
        --replace-fail \
          'CGEventSetDoubleValueField(ev, 129, -sign * 9999.0);' \
          'CGEventSetDoubleValueField(ev, 129, sign * 9999.0);'
    '';

    # This service does not load the scripting addition. Avoid building and
    # embedding the arm64e payload, which does not link cleanly with lld.
    preBuild = ''
      printf '%s\n' \
        'unsigned char __src_osax_payload[] = { 0 };' \
        'unsigned int __src_osax_payload_len = 0;' \
        > src/osax/payload_bin.c
      printf '%s\n' \
        'unsigned char __src_osax_loader[] = { 0 };' \
        'unsigned int __src_osax_loader_len = 0;' \
        > src/osax/loader_bin.c
    '';

    meta = oldAttrs.meta // {
      homepage = "https://github.com/AhsanFazal/yabai";
      changelog = "https://github.com/AhsanFazal/yabai/blob/63d2e10f475e299f20780b18ac2dfe523778195f/CHANGELOG.md";
    };
  });

  desktops = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
  ];

  desktopBindings = builtins.concatStringsSep "\n" (
    map
      (desktop: ''
        ctrl - ${desktop} : yabai -m space --focus ${desktop}
        ctrl + shift - ${desktop} : yabai -m window --space ${desktop} && yabai -m space --focus ${desktop}
      '')
      desktops
  );
in
{
  services.yabai = {
    enable = true;
    enableScriptingAddition = false;
    package = yabaiFork;

    config = {
      layout = "bsp";
      window_placement = "second_child";
      window_topmost = "off";
      window_shadow = "on";
      window_opacity = "off";
      window_border = "off";
      split_ratio = "0.50";
      auto_balance = "off";
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      window_gap = 0;
    };

    extraConfig = ''
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add title="Picture-in-Picture" manage=off sticky=on
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd - return : open -na kitty

      cmd - h : yabai -m window --focus west
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north
      cmd - l : yabai -m window --focus east

      cmd + shift - h : yabai -m window --warp west
      cmd + shift - j : yabai -m window --warp south
      cmd + shift - k : yabai -m window --warp north
      cmd + shift - l : yabai -m window --warp east

      cmd - f : yabai -m window --toggle zoom-fullscreen
      cmd - p : yabai -m window --toggle split
      cmd - 0x2A : yabai -m window --toggle float

      cmd - 0x18 : yabai -m window --resize right:50:0 || yabai -m window --resize left:50:0
      cmd - 0x1B : yabai -m window --resize right:-50:0 || yabai -m window --resize left:-50:0

      ${desktopBindings}
    '';
  };
}
