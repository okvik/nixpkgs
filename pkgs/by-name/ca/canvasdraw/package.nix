{ lib
, stdenv
, fetchzip
, pkg-config

, zlib
, freetype
, fontconfig
, ftgl
, libGLU
, libGL
, glib
, gtk3
, imtoolkit
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "canvasdraw";
  version = "5.14";

  src = fetchzip {
    url = "mirror://sourceforge/canvasdraw/5.14/Docs%20and%20Sources/cd-5.14_Sources.tar.gz";
    hash = "sha256-yYktjKTjbo7pIIWiBtuiypOMrQx9A+jPrN+xPkVHHTk=";
  };

  postPatch = ''
    # sed -i 's@^INCLUDES.*@INCLUDES = . ${imtoolkit}/include@' src/cdim.mak
  '';

  makeFlags = [ "USE_PKGCONFIG=yes" "USE_GTK3=yes" "IM=${imtoolkit}" "IM_LIB=${imtoolkit}/lib" ];
  
  patches = [
    ./fix.patch
  ];

  buildInputs = [
    zlib
    glib
    gtk3.dev
    freetype
    fontconfig
    ftgl
    libGLU
    libGL
    pkg-config
  ];

  installPhase = ''
    runHook preInstall

    install -d "$out/lib"
    install lib/*/*.a "$out/lib"
    install lib/*/*.so "$out/lib"
    install -d "$out/include"
    install include/* "$out/include"

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
