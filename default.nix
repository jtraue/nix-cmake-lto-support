{ sources ? import ./nix/sources.nix
, nixpkgs ? sources.nixpkgs
, pkgs ? import nixpkgs {}
, enableLTO ? true
,
}:

let
  projectWithGcc = pkgs.callPackage projectDefinition {
    inherit enableLTO;
  };

  projectWithClang = with pkgs; projectWithGcc.override {
    # This override breaks LTO detection
    stdenv = pkgs.overrideCC stdenv clang_9;
  };

  projectDefinition =
    { cmake
    , lib
    , ninja
    , nix-gitignore
    , stdenv
    , enableLTO ? false
    , enableSanitizer ? false
    ,
    }:
      stdenv.mkDerivation {
        name = "testproject";
        src = pkgs.nix-gitignore.gitignoreSource [ "nix\n" ] ./.;

        hardeningDisable = [ "all" ];

        nativeBuildInputs = with pkgs; [ cmake ninja ];

        cmakeFlags = [
          "-DENABLE_LTO=${if enableLTO then "On" else "Off"}"
        ];

        doCheck = false;
      };
in
{
  projectGcc = projectWithGcc;
  projectClang = projectWithClang;
}
