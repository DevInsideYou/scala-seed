nixpkgs: system: let
  makeOverlays = java: let
    armOverlay = _: prev:
      let
        pkgsForx86 = import nixpkgs {
          localSystem = "x86_64-darwin";
        };
      in
        prev.lib.optionalAttrs (prev.stdenv.isDarwin && prev.stdenv.isAarch64) {
          inherit (pkgsForx86) bloop;
        };

    ammoniteOverlay = final: prev: {
      # hardcoded because ammonite requires no more than 17 for now
      ammonite = prev.ammonite.override {
        jre = final.temurin-bin-17;
      };
    };

    bloopOverlay = final: prev: {
      bloop = prev.bloop.override {
        jre = final.jre;
      };
    };

    millOverlay = final: prev: {
      mill = prev.mill.override {
        jre = final.jre;
      };
    };

    javaOverlay = final: _: {
      jdk = final.${java};
      jre = final.${java};
    };

    scalaCliOverlay = final: prev: {
      scala-cli = prev.scala-cli.override {
        # hardcoded because scala-cli requires 17 or above
        jre = final.graalvm-ce;
      };
    };
  in [
    javaOverlay
    armOverlay
    bloopOverlay
    scalaCliOverlay
    ammoniteOverlay
    millOverlay
  ];

  makePackages = java: let
    overlays = makeOverlays java;
  in
    import nixpkgs {
      inherit system overlays;
    };

  default = pkgs21;
  pkgs21 = makePackages "graalvm-ce";
  pkgs17 = makePackages "temurin-bin-17";
  pkgs11 = makePackages "temurin-bin-11";
  pkgs8 = makePackages "openjdk8";
in {
  inherit default pkgs21 pkgs17 pkgs11 pkgs8;
}
