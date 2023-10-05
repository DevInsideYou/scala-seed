nixpkgs: system: let
  makeOverlays = java: let
    ammoniteOverlay = final: prev: {
      # hardcoded because ammonite requires no more than 17 for now
      ammonite = prev.ammonite.override {
        jre = final.temurin-bin-17;
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
