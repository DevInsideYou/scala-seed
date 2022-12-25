nixpkgs: system: let
  nameMangling = {
    java = "graalvm17-ce";
  };

  overlays = {
    aarchOverlay = _: prev: let
      pkgsForx86 = import nixpkgs {
        localSystem = "x86_64-darwin";
      };
    in
      prev.lib.optionalAttrs (prev.stdenv.isDarwin && prev.stdenv.isAarch64) {
        inherit (pkgsForx86) scala-cli;
      };

    millOverlay = final: prev: {
      jre = prev.${nameMangling.java};

      mill = prev.mill.override {
        jre = final.jre;
      };
    };

    javaOverlay = final: _: {
      jdk = final.${nameMangling.java};
      jre = final.${nameMangling.java};
    };

    scalaCliOverlay = final: prev: {
      jre = prev.${nameMangling.java};

      scala-cli = prev.scala-cli.override {
        jre = final.jre;
      };
    };
  };

  pkgs = import nixpkgs {
    inherit system;
    overlays = builtins.attrValues overlays;
  };
in
  pkgs
