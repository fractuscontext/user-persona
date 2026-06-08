<!--
SPDX-FileCopyrightText: 2026 Claire Tam <claire.t@student.adelaide.edu.au>
SPDX-FileCopyrightText: 2026 fractuscontext <106440141+fractuscontext@users.noreply.github.com>

SPDX-License-Identifier: LPPL-1.3c
-->

# user-persona: LaTeX Package for UX & HCI

LaTeX Package for creating user personas.

## Who Is This For?

Intended for Software Engineering students, UX researchers, Human-Computer Interaction (HCI) practitioners, and product designers who maintain documentation within a LaTeX workflow.

Supports methodologies found in foundational UX literature
([Cooper, 1999][1]; [Pruitt & Adlin, 2006][2]; [Nielsen, 2019][3]).

[1]: https://doi.org/10.1007/978-3-322-99786-9_1 "Cooper, A. (1999). The Inmates Are Running the Asylum."
[2]: https://doi.org/10.1016/B978-0-12-566251-2.X5000-X "Pruitt, J., & Adlin, T. (2006). The Persona Lifecycle."
[3]: https://doi.org/10.1007/978-1-4471-7427-1 "Nielsen, L. (2019). Personas - User Focused Design."

- **Composable (`\usepackage`):** Integrates into any existing document class
  without replacing it.
  
- **Domain-Neutral & Self-Contained:** Built for general UX research; requires no external PDF theme assets.

## Quick Start

See the example persona by downloading from Github Releases [https://github.com/fractuscontext/user-persona/releases/] or visiting CTAN[(https://ctan.org/pkg/user-persona)].

```latex
% \documentclass{article}
\usepackage{user-persona}

% \begin{document}
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
% \end{document}
```

Please see the full documentation at `./user-persona.tex`.

## Development & Contributing & License

This repository is licened under LPPL-1.3c; and proudly uses [Nix](https://nixos.org/) for a fully reproducible
environment.

- **Enter shell:** `nix develop` (provides `tectonic`, `chktex`, `ctanify`, `reuse`)
- **Build CTAN bundle:** `build-ctan`
- **Lint SPDX headers:** `reuse lint`
