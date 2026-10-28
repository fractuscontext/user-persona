# SPDX-FileCopyrightText: 2026 Claire Tam <claire.tam@student.adelaide.edu.au>
# SPDX-FileCopyrightText: 2026 fractuscontext <106440141+fractuscontext@users.noreply.github.com>
#
# SPDX-License-Identifier: LPPL-1.3c

set shell := ["bash", "-euo", "pipefail", "-c"]

docs := "user-persona.tex user-persona-example.tex user-persona-detailed.tex"

# List available recipes
default:
    @just --list

# Print the version: base36 seconds since the project epoch, zero-padded to 6 digits
version now="":
    #!/usr/bin/env bash
    set -euo pipefail
    start=1767187800
    now="{{ now }}"
    [ -n "$now" ] || now=$(date -u +%s)
    (( now > start )) || now=$((start + 1))
    delta=$((now - start))
    chars=0123456789abcdefghijklmnopqrstuvwxyz
    out=""
    while (( delta > 0 )); do
      out="${chars:delta % 36:1}$out"
      delta=$((delta / 36))
    done
    printf 'v%06s\n' "$out" | tr ' ' 0

# Print the release tag, e.g. v2026.06.08-1221 (UTC)
tag now="":
    #!/usr/bin/env bash
    set -euo pipefail
    now="{{ now }}"
    [ -n "$now" ] || now=$(date -u +%s)
    date -u -d "@$now" +v%Y.%m.%d-%H%M

# Inject a version and today's date into the .sty and manual (computed if omitted)
stamp version="":
    #!/usr/bin/env bash
    set -euo pipefail
    v="{{ version }}"
    [ -n "$v" ] || v=$({{ just_executable() }} version)
    date_slash=$(date -u +%Y/%m/%d)
    date_dash=$(date -u +%Y-%m-%d)
    echo "Injecting version: $v ($date_dash)"
    sed -i -E 's|(\\ProvidesPackage\{user-persona\}\[)[^ ]+ v[^ ]+|\1'"$date_slash $v"'|' user-persona.sty
    sed -i -E 's|\\date\{.+\}|\\date{'"$v"'\\\\'"$date_dash"'}|' user-persona.tex

# Build all PDFs with LuaLaTeX
docs:
    latexmk -lualatex -interaction=nonstopmode -halt-on-error {{ docs }}

# Lint the package source
lint:
    chktex user-persona.sty

# Remove LaTeX build intermediates (keeps PDFs)
clean:
    latexmk -c

# Stamp, build, lint and bundle user-persona.tar.gz for CTAN
ctan version="": (stamp version) docs clean lint
    ctanify --no-tds \
        user-persona-example-screenshot.png \
        user-persona.sty \
        user-persona.tex \
        user-persona.pdf \
        user-persona-example.tex \
        user-persona-example.pdf \
        user-persona-detailed.tex \
        user-persona-detailed.pdf \
        README.md
