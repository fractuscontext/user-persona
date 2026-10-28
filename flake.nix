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
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              reuse
              just
              tex-tools
            ];

            shellHook = ''
              echo "--- Persona LaTeX Package Development environment ---" >&2
              echo "Run \`just\` to list recipes" >&2
              # Keep the luaotfload font cache per project, so it never goes stale against this TeX set
              export TEXMFVAR="$PWD/.texmf-var"
            '';
          };
        }
      );
    };
}
