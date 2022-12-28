nixpkgs: system: let
  makeOverlays = java: let
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
        jre = final.graalvm17-ce;
      };
    };
  in [
    javaOverlay
    scalaCliOverlay
    millOverlay
  ];

  makePackages = java: let
    overlays = makeOverlays java;
  in
    import nixpkgs {
      inherit system overlays;
    };

  default = pkgs17;
  pkgs17 = makePackages "graalvm17-ce";
  pkgs11 = makePackages "graalvm11-ce";
  pkgs8 = makePackages "openjdk8";
in {
  inherit default pkgs17 pkgs11 pkgs8;
}
