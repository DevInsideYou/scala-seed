nixpkgs: nixpkgsForGraal21: system:
let
  makeOverlays =
    java: javaVersion:
    let
      graalAliasOverlay = final: prev: {
        graalvm-ce = final.graalvmPackages.graalvm-ce;
      };

      ammoniteOverlay = final: prev: {
        ammonite = prev.ammonite.override {
          jre = final.jre;
        };
      };

      bloopOverlay =
        final: prev:
        let
          pkgsForGraal21 = import nixpkgsForGraal21 {
            inherit system;
          };
        in
        {
          bloop = prev.bloop.override {
            # hardcoded because bloop requires 17 or above
            jre =
              if javaVersion == 21 then
                pkgsForGraal21.${java} # graal 21
              else if javaVersion < 17 then
                final.graalvm-ce # graal 25 at the time # this override global java... why?
              else
                final.jre;
          };
        };

      millOverlay =
        final: prev:
        let
          pkgsForGraal21 = import nixpkgsForGraal21 {
            inherit system;
          };
        in
        {
          mill = prev.mill.override {
            # hardcoded because mill requires 11 or above
            jre =
              if javaVersion == 21 then
                pkgsForGraal21.${java} # graal 21
              else if javaVersion < 11 then
                final.graalvm-ce # graal 25 at the time
              else
                final.${java};
          };
        };

      javaOverlay =
        final: _:
        let
          pkgsForGraal21 = import nixpkgsForGraal21 {
            inherit system;
          };
        in
        {
          jdk = if javaVersion == 21 then pkgsForGraal21.${java} else final.${java};

          jre = if javaVersion == 21 then pkgsForGraal21.${java} else final.${java};
        };

      scalaCliOverlay =
        final: prev:
        let
          pkgsForGraal21 = import nixpkgsForGraal21 {
            inherit system;
          };
        in
        {
          scala-cli = prev.scala-cli.override {
            # hardcoded because scala-cli requires 17 or above
            jre =
              if javaVersion == 21 then
                pkgsForGraal21.${java} # graal 21
              else if javaVersion < 17 then
                final.graalvm-ce # graal 25 at the time
              else
                final.${java};
          };
        };
    in
    [
      graalAliasOverlay
      javaOverlay
      # bloopOverlay
      scalaCliOverlay
      ammoniteOverlay
      millOverlay
    ];

  makePackages =
    java: javaVersion:
    let
      overlays = makeOverlays java javaVersion;
    in
    import nixpkgs {
      inherit system overlays;
    };

  default = pkgs25;
  pkgs25 = makePackages "graalvm-ce" 25;
  pkgs21 = makePackages "graalvm-ce" 21;
  pkgs17 = makePackages "temurin-bin-17" 17;
  pkgs11 = makePackages "temurin-bin-11" 11;
  pkgs8 = makePackages "openjdk8" 8;
in
{
  inherit
    default
    pkgs25
    pkgs21
    pkgs17
    pkgs11
    pkgs8
    ;
}
