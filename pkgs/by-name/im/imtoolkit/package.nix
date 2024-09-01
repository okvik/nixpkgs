{ lib
, stdenv
, fetchzip
, pkg-config

, zlib
, fftw
, fftwFloat
, libpng
, lua
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imtoolkit";
  version = "3.15";

  src = fetchzip {
    url = "mirror://sourceforge/imtoolkit/3.15/Docs%20and%20Sources/im-3.15_Sources.tar.gz";
    hash = "sha256-QpbxVUKyvr8nK7rLo1l5vpUZRhxpGeHUp7EW1Y/Vinc=";
  };
  
  patches = [
    ./fix.patch
  ];

  buildInputs = [
    lua
    zlib
    fftw
    fftwFloat
    libpng
    pkg-config
  ];

  makeFlags = [];

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
