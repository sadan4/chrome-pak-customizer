{ stdenv
, gnumake
, cmake
, lib
}: stdenv.mkDerivation (finalAttrs: {
  pname = "chrome-pak-customizer";
  version = "1.0.1";

  src = ./.;

  nativeBuildInputs = [
    cmake
    gnumake
  ];

  configurePhase = ''
    runHook preConfigure

    mkdir build
    pushd build

    cmake -DLGPL=OFF ..

    popd

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pushd build

    make

    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv build/pak $out/bin/pak

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchelf $out/bin/pak

    runHook postFixup
  '';

  meta = {
    description = "Tool for managing chrome pak files";
    homepage = "https://github.com/sadan4/chrome-pak-customizer";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pak";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
    ];
  };
})
