{ pkgs, ... }:
let
  zathuraPdfPoppler = pkgs.zathuraPkgs.zathura_pdf_poppler.overrideAttrs (old: {
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dtests=disabled" ];
    nativeBuildInputs = builtins.filter (input: (input.pname or "") != "appstream") old.nativeBuildInputs;
  });
  zathuraWithPdf = pkgs.zathura.override {
    plugins = [ zathuraPdfPoppler ];
  };
  zathuraApp = pkgs.stdenvNoCC.mkDerivation {
    pname = "zathura-app";
    version = zathuraWithPdf.version;

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      app="$out/Applications/Zathura.app"
      mkdir -p "$app/Contents/MacOS"

      cat > "$app/Contents/Info.plist" <<'EOF'
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>Zathura</string>
        <key>CFBundleIdentifier</key>
        <string>org.pwmt.zathura</string>
        <key>CFBundleName</key>
        <string>Zathura</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>${zathuraWithPdf.version}</string>
      </dict>
      </plist>
      EOF

      cat > "$app/Contents/MacOS/Zathura" <<'EOF'
      #!/bin/sh
      exec ${zathuraWithPdf}/bin/zathura "$@"
      EOF
      chmod +x "$app/Contents/MacOS/Zathura"

      runHook postInstall
    '';
  };
in
{
  home.packages = [ zathuraApp ];

  programs.zathura = {
    enable = true;
    package = zathuraWithPdf;
    options = {
      default-bg = "#282828";
      default-fg = "#ebdbb2";
      completion-bg = "#282828";
      completion-fg = "#ebdbb2";
      completion-group-bg = "#3c3836";
      completion-group-fg = "#fabd2f";
      completion-highlight-bg = "#504945";
      completion-highlight-fg = "#fbf1c7";
      notification-bg = "#282828";
      notification-fg = "#ebdbb2";
      notification-error-bg = "#cc241d";
      notification-error-fg = "#fbf1c7";
      notification-warning-bg = "#d79921";
      notification-warning-fg = "#282828";
      inputbar-bg = "#282828";
      inputbar-fg = "#ebdbb2";
      statusbar-bg = "#3c3836";
      statusbar-fg = "#ebdbb2";
      highlight-color = "#fabd2f";
      highlight-active-color = "#fe8019";
      render-loading-bg = "#282828";
      render-loading-fg = "#ebdbb2";
      index-bg = "#282828";
      index-fg = "#ebdbb2";
      index-active-bg = "#504945";
      index-active-fg = "#fbf1c7";
      recolor = true;
      recolor-lightcolor = "#282828";
      recolor-darkcolor = "#ebdbb2";
      recolor-keephue = true;
    };
  };
}
