{ lib
, stdenv
, fetchFromGitHub

, python3Packages
, writeShellScriptBin
, makeWrapper
, qt6
, cyclonedds
}:
let
  pyside-tools-rcc = writeShellScriptBin "pyside6-rcc" ''
    exec ${qt6.qtbase}/libexec/pyside6-rcc "$@"
  '';
  python = python3Packages.python.withPackages (pkgs: with pkgs; [ pyside6 cyclonedds-python ]);
in
stdenv.mkDerivation rec {
  pname = "cyclonedds-insight";
  version = "unstable-2024-07-03";

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-insight";
    rev = "586fdfda539b51e4609e3ffc03c37446babe4ea0";
    hash = "sha256-PWrBGVViKMVcO5Rlagts/1roJ+7aO6wfWnWoht7BOLM=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    pyside-tools-rcc
    python
  ];
  
  patchPhase = ''
    substituteInPlace ./resources.qrc \
      --replace-quiet res/ $out/share/res/ \
      --replace-quiet src/ $out/share/src/
  '';

  buildPhase = ''
    runHook preBuild

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/share/src
    cp -r src res $out/share

    pyside6-rcc ./resources.qrc -o $out/share/src/qrc_file.py
    makeWrapper ${python}/bin/python3 $out/bin/testis \
                --add-flags $out/share/src/main.py \
                --set CYCLONEDDS_HOME ${cyclonedds}
  '';

  meta = {
    description = "";
    homepage = "https://github.com/eclipse-cyclonedds/cyclonedds-insight";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ kvik ];
    mainProgram = "cyclonedds-insight";
    platforms = lib.platforms.all;
  };
}
