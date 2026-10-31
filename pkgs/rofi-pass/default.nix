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
    rev = "7d6caf35111687096d352971000f740b50a3d257";
    hash = "sha256-TbvpFAAvIAaZeb4Wz+R6Otomc7jVck35grKHcSAq0pk=";
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
