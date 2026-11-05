{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "yvnth";
    repo = "rofi-pass";
    rev = "a66177636813903525db6b5702af4e4f7276e9bc";
    hash = "sha256-oRgeKHUSeSG3tOypVnMAG5l2t8QzNz+mYW5e1GDrwk0=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 rofi-pass $out/bin/rofi-pass

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgram $out/bin/rofi-pass \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          util-linuxMinimal
          gnugrep
          libnotify
          pwgen
          findutils
          gawk
          gnused
          rofi
          (pass-wayland.withExtensions (ext: [ ext.pass-otp ]))
          wl-clipboard
          wtype
        ]
      }" \
      --set-default ROFI_PASS_BACKEND wtype \
      --set-default ROFI_PASS_CLIPBOARD_BACKEND wl-clipboard

    runHook postFixup
  '';
}
