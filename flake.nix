{
  description = "Crosslink monolith flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem =
        { pkgs, ... }:
        let
          zebraSrc = ./.;

          commonNativeBuildInputs = with pkgs; [
            cargo
            rustc
            pkg-config
            protobuf
            cmake
            clang
            perl
          ];

          commonBuildInputs = with pkgs; [
            openssl
          ];

          mkZebradDerivation =
            {
              pname,
              doCheck ? false,
              cargoTestFlags ? [ ],
            }:
            pkgs.rustPlatform.buildRustPackage {
              inherit pname doCheck cargoTestFlags;
              version = "0.0.0";
              src = zebraSrc;
              cargoRoot = "zebra-crosslink";
              cargoLock = {
                lockFile = ./zebra-crosslink/Cargo.lock;
              };
              cargoBuildFlags = [ "--package" "zebrad" ];
              nativeBuildInputs = commonNativeBuildInputs;
              buildInputs = commonBuildInputs;

              PROTOC = "${pkgs.protobuf}/bin/protoc";
              OPENSSL_DIR = "${pkgs.openssl.dev}";
              LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
            };
        in
        {
          packages.default = mkZebradDerivation {
            pname = "crosslink-monolith";
          };

          checks.zebrad-lib-tests = mkZebradDerivation {
            pname = "zebrad-lib-tests";
            doCheck = true;
            cargoTestFlags = [ "--package" "zebrad" "--lib" ];
          };

          checks.zebrad-config-tests = mkZebradDerivation {
            pname = "zebrad-config-tests";
            doCheck = true;
            cargoTestFlags = [ "--package" "zebrad" "--test" "config" ];
          };

          devShells.default = pkgs.mkShell {
            buildInputs = commonBuildInputs;
            nativeBuildInputs = commonNativeBuildInputs;

            PROTOC = "${pkgs.protobuf}/bin/protoc";
            OPENSSL_DIR = "${pkgs.openssl.dev}";
            LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
          };
        };
    };
}
