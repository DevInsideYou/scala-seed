nixpkgs: nixpkgsForGraal: system: let
  makeOverlays = java: graal: let
    ammoniteOverlay = final: prev: let
      pkgsForGraal = import nixpkgsForGraal {
        inherit system;
      };
    in {
      ammonite = prev.ammonite.override {
        jre =
          if graal
          then pkgsForGraal.${java}
          else final.${java};
      };
    };

    bloopOverlay = final: prev: {
      bloop = prev.bloop.override {
        jre = final.jre;
      };
    };

    millOverlay = _: prev: let
      pkgsForGraal = import nixpkgsForGraal {
        inherit system;
      };
    in {
      mill = prev.mill.override {
        # hardcoded because mill requires 11 or above
        jre = pkgsForGraal.graalvm-ce;
      };
    };

    javaOverlay = final: _: let
      pkgsForGraal = import nixpkgsForGraal {
        inherit system;
      };
    in {
      jdk =
        if graal
        then pkgsForGraal.${java}
        else final.${java};

      jre =
        if graal
        then pkgsForGraal.${java}
        else final.${java};
    };

    scalaCliOverlay = _: prev: let
      pkgsForGraal = import nixpkgsForGraal {
        inherit system;
      };
    in {
      scala-cli = prev.scala-cli.override {
        # hardcoded because scala-cli requires 17 or above
        jre = pkgsForGraal.graalvm-ce;
      };
    };
  in [
    javaOverlay
    bloopOverlay
    scalaCliOverlay
    ammoniteOverlay
    millOverlay
  ];

  makePackages = java: graal: let
    overlays = makeOverlays java graal;
  in
    import nixpkgs {
      inherit system overlays;
    };

  default = pkgs21;
  pkgs21 = makePackages "graalvm-ce" true;
  pkgs17 = makePackages "temurin-bin-17" false;
  pkgs11 = makePackages "temurin-bin-11" false;
  pkgs8 = makePackages "openjdk8" false;
in {
  inherit default pkgs21 pkgs17 pkgs11 pkgs8;
}
