{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    daphne-nix.url = "github:GuilloteauQ/daphne-nix";
  };

  outputs = { self, nixpkgs, daphne-nix }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {

      devShells.${system} = {
        default = pkgs.mkShell { buildInputs = [ pkgs.snakemake pkgs.wget ]; };

        daphne-shell = pkgs.mkShell {
          buildInputs = [ daphne-nix.packages.${system}.daphne ];
        };

        daphne-cst-shell = pkgs.mkShell {
          buildInputs = [
            (daphne-nix.packages.${system}.daphne.overrideAttrs
              (finalAttrs: previousAttrs: {
                patchPhase = ''
                  ${previousAttrs.patchPhase}
                  patch -Np1 -i ${./src/cst_sched.patch}
                '';
              }))
          ];
        };

        record-shell = pkgs.mkShell {
          buildInputs = [
            pkgs.vhs
          ];
        };

        rshell = pkgs.mkShell {
          buildInputs = [
            (pkgs.rWrapper.override {
              packages = with pkgs.rPackages; [ tidyverse ];
            })
          ];
        };

        notes = pkgs.mkShell {
          buildInputs = [ pkgs.emacs ];
          shellHook = ''
            ${pkgs.emacs}/bin/emacs -q -l ./.init.el notes.org
            exit
          '';
        };
      };

    };
}
