{ lib
, stdenv
, fetchzip
, pkg-config

, glib
, gtk3
, libGLU
, libGL
, ftgl
, fontconfig
, imtoolkit
, canvasdraw
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iup";
  version = "3.31";

  src = fetchzip {
    url = "mirror://sourceforge/iup/3.31/Docs%20and%20Sources/iup-3.31_Sources.tar.gz";
    hash = "sha256-3vZcQWKG49r7fKfDSHyn73G2Ywtj4ARvu4uqmLhh4Dk=";
  };

  makeFlags = [
    "USE_PKGCONFIG=yes"
    "USE_GTK3=yes"
    "IM=${imtoolkit}"
    "IM_LIB=${imtoolkit}/lib"
    "CD=${canvasdraw}"
    "CD_LIB=${canvasdraw}/lib"
  ];
  
  patches = [
    ./fix.patch
  ];

  buildInputs = [
    glib
    gtk3.dev
    fontconfig
    libGLU
    libGL
    ftgl
    imtoolkit
    canvasdraw
    pkg-config
  ];

  installPhase = ''
    runHook preInstall

    install -d "$out/lib"
    install lib/*/*.a "$out/lib"
    install lib/*/*.so "$out/lib"
    install -d "$out/include"
    install include/* "$out/include"
    install -d "$out/bin"
    install bin/*/* "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "";
    homepage = "";
    changelog = "";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kvik ];
  };
})
