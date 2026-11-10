{ lib, appimageTools, fetchurl }:

let
  pname = "artcraft-launcher";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/storytold/craft-launcher/releases/download/v${version}/artcraft-launcher-${version}-linux-x86_64.AppImage";
    hash = "sha256-Dd/MbHA7mlz3gpV1DhA7IHbVRLsmM8cs5Mq1ISMm2N4=";
  };

  # Unpacked copy, only used to pull the desktop entry and icons out.
  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # TryExec makes GNOME hide the entry when it can't resolve the program on its own
    # PATH; the launcher's own AppRun drops it for the same reason.
    mkdir -p $out/share/applications
    sed '/^TryExec=/d' ${contents}/usr/share/applications/ai.storyteller.artcraft-launcher.desktop \
      > $out/share/applications/ai.storyteller.artcraft-launcher.desktop
    mkdir -p $out/share/icons
    cp -r ${contents}/usr/share/icons/hicolor $out/share/icons/hicolor
  '';

  meta = {
    description = "Install, update and open every app in the Craft App Suite (prebuilt AppImage)";
    homepage = "https://getartcraft.com/apps";
    license = with lib.licenses; [ mit asl20 ];
    mainProgram = "artcraft-launcher";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
