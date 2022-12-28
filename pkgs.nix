nixpkgs: system: let
  makeOverlays = java: {
    millOverlay = final: prev: {
      jre = prev.${java};

      mill = prev.mill.override {
        jre = final.jre;
      };
    };

    javaOverlay = final: _: {
      jdk = final.${java};
      jre = final.${java};
    };

    scalaCliOverlay = final: prev: {
      # hardcoded because the scala-cli requires 17 or above
      jre = prev.${"graalvm17-ce"};

      scala-cli = prev.scala-cli.override {
        jre = final.jre;
      };
    };
  };

  makePackages = java: let
    overlays = makeOverlays java;
  in
    import nixpkgs {
      inherit system;
      overlays = builtins.attrValues overlays;
    };

  default = pkgs17;
  pkgs17 = makePackages "graalvm17-ce";
  pkgs11 = makePackages "graalvm11-ce";
  pkgs8 = makePackages "openjdk8";
in {
  inherit default pkgs17 pkgs11 pkgs8;
}
