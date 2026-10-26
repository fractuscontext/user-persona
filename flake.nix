# SPDX-FileCopyrightText: 2026 Claire Tam <claire.tam@student.adelaide.edu.au>
# SPDX-FileCopyrightText: 2026 fractuscontext <106440141+fractuscontext@users.noreply.github.com>
#
# SPDX-License-Identifier: LPPL-1.3c

{
  description = "Persona LaTeX Package Development Environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};

          tex-tools = pkgs.texliveSmall.withPackages (
            ps: with ps; [
              latexmk
              ctanify
              chktex
              # user-persona.sty dependencies
              tcolorbox
              pgf
              pgfopts
              fontawesome5
              enumitem
              environ
              tikzfill
              pdfcol
              # examples
              helvetic
              mwe
            ]
          );

          base36 = pkgs.writeScriptBin "base36" ''
            #!/usr/bin/env bash
            set -e
            num=$1
            chars="0123456789abcdefghijklmnopqrstuvwxyz"
            res=""
            while [ $num -gt 0 ]; do
              res="''${chars:$(($num % 36)):1}$res"
              num=$(($num / 36))
            done
            echo "''${res:-0}"
          '';

          # New standalone version generator
          get-version = pkgs.writeScriptBin "get-version" ''
            #!/usr/bin/env bash
            set -e
            START_TIME=1767187800
            CURRENT_TIME=$(date -u +%s)

            if [ "$CURRENT_TIME" -le "$START_TIME" ]; then
                CURRENT_TIME=$(($START_TIME + 1))
            fi

            DELTA=$((CURRENT_TIME - START_TIME))
            BASE36_RAW=$(base36 $DELTA)

            # Print the formatted version
            echo "v$(printf "%06s" "$BASE36_RAW" | tr ' ' '0')"
          '';

          build-ctan = pkgs.writeScriptBin "build-ctan" ''
            set -e

            # Accept version from arguments, or calculate it if none provided
            VERSION_STR=$1
            if [ -z "$VERSION_STR" ]; then
              VERSION_STR=$(get-version)
            fi

            DATE_SLASH=$(date -u +'%Y/%m/%d')
            DATE_DASH=$(date -u +'%Y-%m-%d')

            echo "Injecting version: $VERSION_STR ($DATE_DASH)"

            sed -i -E "s|(\\\\ProvidesPackage\{user-persona\}\[)[^ ]+ v[^ ]+|\1$DATE_SLASH $VERSION_STR|" user-persona.sty
            sed -i -E "s|\\\\date\{.+\}|\\\\date\{$VERSION_STR\\\\\\\\$DATE_DASH\}|" user-persona.tex

            echo "Building Documentation with LuaLaTeX..."
            for doc in user-persona user-persona-example user-persona-detailed; do
              latexmk -lualatex -interaction=nonstopmode -halt-on-error "$doc.tex"
            done
            latexmk -c

            echo "Linting..."
            chktex user-persona.sty

            echo "Creating CTAN bundle..."
            ctanify --no-tds \
                    user-persona-example-screenshot.jpeg \
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
              base36
              get-version
              build-ctan
              tex-tools
            ];

            shellHook = ''
              echo "--- Persona LaTeX Package Development environment ---" >&2
              echo "Commands: build-ctan [version], get-version, base36, lualatex, latexmk, chktex, ctanify" >&2
              # Keep the luaotfload font cache per project, so it never goes stale against this TeX set
              export TEXMFVAR="$PWD/.texmf-var"
            '';
          };
        }
      );
    };
}
