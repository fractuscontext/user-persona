<!--
SPDX-FileCopyrightText: 2026 Claire Tam <claire.t@student.adelaide.edu.au>
SPDX-FileCopyrightText: 2026 fractuscontext <106440141+fractuscontext@users.noreply.github.com>

SPDX-License-Identifier: LPPL-1.3c
-->

# user-persona

A LaTeX package for typesetting structured user persona sheets in UX and HCI documentation.


## What Is a User Persona?

A **user persona** is a fictitious but research-grounded representation of a target user group,
synthesising observed behaviours, goals, and frustrations into a named, humanised archetype
[Cooper 1999]. Personas are widely used in user-centred design to keep real user needs visible
throughout product development — from early requirements gathering through to final evaluation
[Pruitt & Adlin 2006]. They serve as a shared vocabulary between designers, developers, and
stakeholders, anchoring design decisions in empirical user research rather than internal
assumptions [Nielsen 2019].

> **[Cooper 1999]** A. Cooper, *The Inmates Are Running the Asylum*. Sams Publishing, 1999.
>
> **[Pruitt & Adlin 2006]** J. Pruitt and T. Adlin, *The Persona Lifecycle: Keeping People in
> Mind Throughout Product Design*. Morgan Kaufmann, 2006. ISBN: 978-0-12-566251-2
>
> **[Nielsen 2019]** L. Nielsen, *Personas — User Focused Design*. Springer, 2019.
> doi:[10.1007/978-1-4471-7427-1](https://doi.org/10.1007/978-1-4471-7427-1)

## About This Package

The `user-persona` package provides a structured `persona` environment and a set of commands
for composing professional persona sheets directly in LaTeX. It is intended for UX researchers,
Human-Computer Interaction (HCI) practitioners, and product designers who maintain documentation
within a LaTeX workflow.

Unlike the `persona_landscape` document class from Holzinger et al. (2022) — which targets
AI-specific personas in medical contexts and requires a directory of external PDF image assets —
`user-persona` is:

- A **composable package** (`\usepackage`), not a document class: integrates into any existing
  document (thesis, report, CHI paper, design brief) without replacing its root class.
- **Domain-neutral**: suitable for any UX, product, or service design context.
- **Self-contained**: no external PDF theme assets required.
- Released under **LPPL-1.3c** for full CTAN distribution.

## Quick Start

```latex
\documentclass{article}
\usepackage{user-persona}

\begin{document}
\begin{persona}{Zhang Wei}
  \personaphoto{photo.jpg}
  \personaquote{``If the robot crashes, I reboot it and send a WeChat voice note.''}
  \personafact{Age}{30}
  \personafact{Location}{Mainland China}

  \personasection{Goals}{PersonaGreen}{
    \item Complete the shift with zero system failures.
    \item Find content to combat boredom during monitoring.
  }

  \personasection[right]{Pain Points}{PersonaRed}{
    \item Physical strain from 10 hours of screen glare.
    \item Frustration with text-heavy Western software interfaces.
  }
\end{persona}
\end{document}
```

See `user-persona-example.tex` for a minimal example and `user-persona-detailed.tex` for a
full demonstration.

## Commands

### Environment

```latex
\begin{persona}{Name} ... \end{persona}
```

### Identity

| Command | Description |
|---|---|
| `\personaphoto{path}` | Portrait image |
| `\personaquote{text}` | Pull-quote |
| `\personafact{Key}{Value}` | Identity table row |

### Content Cards

| Command | Description |
|---|---|
| `\personasection[pos]{Title}{Color}{Items}` | Bulleted list card |
| `\personacard[pos]{Title}{Color}{Content}` | Free-content card |
| `\personacontext[pos]{Title}{Content}` | Shorthand grey context card |

`pos` accepts `left`, `right` (default), or `span`.

### Inline Elements

| Command | Description |
|---|---|
| `\personapill{text}` | Rounded pill label |
| `\personabrand[img]{path}` | Image icon badge |
| `\personabrand[fa]{\faCommand}` | FontAwesome icon badge |

## Predefined Colours

| Name | Suggested Use |
|---|---|
| `PersonaDark` | Header, dark cards |
| `PersonaGreen` | Goals, Core Needs |
| `PersonaBlue` | Behaviours |
| `PersonaRed` | Pain Points |
| `PersonaGrey` | Context, supplementary info |

## Related Work

Holzinger et al. (2022) provide a LaTeX document class (`persona_landscape`) for AI-specific
persona sheets, released under CC BY-NC 4.0 as a GitHub repository. The `user-persona` package
addresses a complementary but distinct need: a general-purpose, composable, CTAN-distributed
package for UX and HCI documentation workflows.

> A. Holzinger, M. Kargl, B. Kipperer, P. Regitnig, M. Plass, and H. Müller,
> "Personas for Artificial Intelligence (AI): an Open Source Toolbox,"
> *IEEE Access*, vol. 10, pp. 23732–23747, 2022.
> doi:[10.1109/ACCESS.2022.3154776](https://doi.org/10.1109/ACCESS.2022.3154776)

## License

Released under the
[LaTeX Project Public License, version 1.3c](https://www.latex-project.org/lppl/lppl-1-3c/)
(LPPL-1.3c).

## Contributing

[Github:] uses a [Nix flake](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake)
to provide a fully reproducible development environment.

**Enter the development shell:**
```sh
nix develop
```

This provides `tectonic`, `chktex`, `ctanify`, and `reuse` on your PATH.

**Build the CTAN bundle:**
```sh
build-ctan
```

This will:
1. Compile all documentation PDFs via `tectonic`
2. Lint `user-persona.sty` via `chktex`
3. Produce `user-persona.tar.gz` via `ctanify --no-tds`

**Check SPDX licence headers:**
```sh
reuse lint
```
