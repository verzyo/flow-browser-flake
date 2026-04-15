{
  description = "Flow Browser";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs: let
    sys = "x86_64";
    system = "${sys}-linux";

    pname = "flow-browser";
    version = "0.12.0";

    src = pkgs.fetchurl {
      url = "https://github.com/MultiboxLabs/flow-browser/releases/download/v${version}/${pname}-${version}-${sys}.AppImage";
      hash = "sha256-ixcVp7789E+ZO33HA18csUyiRDUmxysW1XeJNL3+3Bo=";
    };

    appImageContents = appimageTools.extract {
      inherit pname version src;
    };

    pkgs = inputs.nixpkgs.legacyPackages.${system};
    inherit (pkgs) appimageTools;
  in {
    packages."${system}" = {
      default = inputs.self.packages.${system}.flow;

      flow = appimageTools.wrapType2 {
        inherit version src;

        pname = "flow";

        extraInstallCommands = ''
          install -m 444 -D ${./flow-browser.desktop} $out/share/applications/${pname}.desktop
          install -m 444 -D ${appImageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
            $out/share/icons/hicolor/512x512/apps/${pname}.png
        '';
      };
    };
  };
}
