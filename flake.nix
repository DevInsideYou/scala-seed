{
  description = "A flake for getting started with Scala.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgsForGraal21.url = "github:nixos/nixpkgs?rev=1939434b4ae04cb855edec936573c778a9ddeab0";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgsForGraal21,
      flake-utils,
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import ./pkgs.nix nixpkgs nixpkgsForGraal21 system;

        makeShell =
          p:
          p.mkShell {
            buildInputs = with p; [
              ammonite
              bloop
              coursier
              jdk
              mill
              sbt
              scala-cli
              scalafmt
            ];
          };
      in
      {
        devShells = {
          default = makeShell pkgs.default;
          java25 = makeShell pkgs.pkgs25;
          java21 = makeShell pkgs.pkgs21;
          java17 = makeShell pkgs.pkgs17;
          java11 = makeShell pkgs.pkgs11;
          java8 = makeShell pkgs.pkgs8;
        };

        formatter = pkgs.default.nixfmt;
      }
    );
}
