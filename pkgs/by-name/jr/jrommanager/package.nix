{
  lib,
  fetchurl,
  appimageTools,
}:
let
  version = "3.0.5";
  pname = "jrommanager";

  src = fetchurl {
    url = "https://github.com/optyfr-org/JRomManager/releases/download/${version}/JRomManager-3.0.0-x86_64.AppImage";
    hash = "sha256-A3X8G0Hr57iBoQJGWTwxLBV6fwwhBPH1vCPZaI1N6cI=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/com.github.optyfr-org.JRomManager.desktop
    mkdir -p $out/share/icons
    cp ${appimageContents}/JRomManager.png $out/share/icons/

    substituteInPlace $out/share/applications/com.github.optyfr-org.JRomManager.desktop \
      --replace-fail 'Exec=/opt/jrommanager/bin/JRomManager' 'Exec=${pname}' \
      --replace-fail 'Name=JRomManager-3.0.0' 'Name=JRomManager'
  '';

  meta = {
    description = "A Rom Manager entirely written in Java and released under GPL-2";
    homepage = "https://github.com/optyfr-org/JRomManager";
    license = lib.licenses.gpl2;
    mainProgram = "jrommanager";
    maintainers = with lib.maintainers; [ tallesCoelho ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
