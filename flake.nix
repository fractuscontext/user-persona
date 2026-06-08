# SPDX-FileCopyrightText: 2026 Claire Tam <claire.tam@student.adelaide.edu.au>
# SPDX-FileCopyrightText: 2026 fractuscontext <106440141+fractuscontext@users.noreply.github.com>
#
# SPDX-License-Identifier: LPPL-1.3c

{
  description = "Persona LaTeX Package Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-revert.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs =
    { self, nixpkgs, nixpkgs-revert }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      nixpkgsRevertFor = forAllSystems (system: import nixpkgs-revert { inherit system; });
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          pkgs-revert = nixpkgsRevertFor.${system}; 
          
          tex-tools = pkgs.texlive.combine {
            inherit (pkgs.texlive)
              scheme-minimal
              ctanify
              chktex
              ;
          };

          build-ctan = pkgs.writeScriptBin "build-ctan" ''
            set -e
            echo "Building Documentation with Tectonic..."
            tectonic user-persona.tex
            tectonic user-persona-example.tex
            tectonic user-persona-detailed.tex

            echo "Linting..."
            chktex user-persona.sty

            echo "Creating CTAN bundle..."
            ctanify --no-tds \
                    user-persona.sty \
                    user-persona.tex \
                    user-persona.pdf \
                    user-persona-example.tex \
                    user-persona-example.pdf \
                    user-persona-detailed.tex \
                    user-persona-detailed.pdf \
                    README.md
          '';
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              reuse
              pkgs-revert.tectonic 
              build-ctan
              tex-tools
            ];

            shellHook = ''
              echo "--- Persona LaTeX Package Development environment ---"
              echo "Commands: build-ctan (reproducible build), tectonic, chktex, ctanify"
              
              export TECTONIC_CACHE_DIR="$PWD/.tectonic-cache"
            '';
          };
        }
      );
    };
}