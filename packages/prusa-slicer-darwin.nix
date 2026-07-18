{ fetchurl
, lib
, stdenvNoCC
, undmg
}:
stdenvNoCC.mkDerivation {
  pname = "PrusaSlicer";
  version = "2.9.5";

  src = fetchurl {
    url = "https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.9.5/PrusaSlicer-2.9.5.dmg";
    hash = "sha256-53Bf9e7zFNToayUAhuJLp+w7KNJHIy5F4hFCDDGlcA8=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Original Prusa Drivers/PrusaSlicer.app" "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "G-code generator for 3D printers";
    homepage = "https://github.com/prusa3d/PrusaSlicer";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.darwin;
    mainProgram = "PrusaSlicer";
  };
}
