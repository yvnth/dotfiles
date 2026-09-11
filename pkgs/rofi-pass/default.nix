{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  unstableGitUpdater,
  coreutils,
  util-linuxMinimal,
  gnugrep,
  libnotify,
  pwgen,
  findutils,
  gawk,
  gnused,
  rofi,
  pass-wayland,
  wl-clipboard,
  wtype,
}:

stdenv.mkDerivation {
  pname = "rofi-pass";
  version = "2.0.2-unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "carnager";
    repo = "rofi-pass";
    rev = "37c4c862deb133a85b7d72989acfdbd2ef16b8ad";
    hash = "sha256-1lPNj47vTPLBK7mVm+PngV8C/ZsjJ2EN4ffXGU2TlQo=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -a rofi-pass $out/bin/rofi-pass
    mkdir -p $out/share/doc/rofi-pass/
    cp -a config.example $out/share/doc/rofi-pass/config.example
    runHook postInstall
  '';

  wrapperPath = lib.makeBinPath [
    coreutils
    findutils
    gawk
    gnugrep
    gnused
    libnotify
    pwgen
    rofi
    util-linuxMinimal
    (pass-wayland.withExtensions (ext: [ ext.pass-otp ]))
    wl-clipboard
    wtype
  ];

  fixupPhase = ''
    runHook preFixup
    patchShebangs $out/bin
    wrapProgram $out/bin/rofi-pass \
      --prefix PATH : "$wrapperPath" \
      --set-default ROFI_PASS_BACKEND wtype \
      --set-default ROFI_PASS_CLIPBOARD_BACKEND wl-clipboard
    runHook postFixup
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Script to make rofi work with password-store";
    mainProgram = "rofi-pass";
    homepage = "https://github.com/carnager/rofi-pass";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
  };
}
