---
name: target-workflow
description: Per-target workspace layout for engagement output — findings, attack chains, confirmed exploits, and captured material, gated by the active mode
---

# Target Workflow

Every assessed target gets one directory under `Targets/`, named after the target slug. The directory is the engagement's evidence trail: what was found, how it chains, what is proven runnable, and what material was captured.

## Gate: mode check first

Create a target directory only for a target authorized under the active mode (see `scope_and_modes.md`):

- **WhiteHat** — target must appear in the program's scope file. No exceptions.
- **Engagement** — target must be named in the signed authorization.
- **BlackHat** — target must be explicitly authorized for testing; discovered pivots do not automatically become in scope. Inside the directory the bar is higher, not lower: chains must carry the four viability fields from `scope_and_modes.md`, and `exploits/` entries must state the boundary they cross and their detection footprint, not just the run steps.

No matching mode, no directory. A target discovered mid-scan is not authorized until the mode's rule says it is.

## Layout

```
Targets/
└── <target-slug>/
    ├── findings/        # one markdown file per finding
    ├── attack-chain/    # how findings combine into paths to impact
    ├── exploits/        # confirmed, runnable PoCs only
    └── captured/        # secrets and proof material — handle with care
```

Skeleton: `.agents/templates/engagement/Targets/` — copied into the engagement workspace by `new-engagement.sh`; add a target with `cp -r Targets/example-target Targets/<slug>`.

## findings/

One file per finding, named `<nn>-<short-slug>.md`. Same issue stays one file — see "One issue, one file" in SKILL.md. Content follows the reporting contract (see SKILL.md, Finding Records): all required fields, with `poc_description` and `poc_script_code` non-empty. A finding without a PoC is a lead, not a finding — keep leads in `attack-chain/` notes until proven.

## attack-chain/

Markdown or diagram files describing how findings combine: entry point → privilege or access gained → next surface → impact. Each node references a file in `findings/` by name. This is the narrative layer over the threat model (`run_state.md`): the threat model is per-target shared state, the attack chain is the human-readable path through it.

## exploits/

Confirmed-runnable proof only. Entry bar:

1. The exploit was executed successfully against the target, in scope, under the active mode.
2. The file records preconditions, exact run steps, expected result, and cleanup (what to revert on the target).
3. It maps to a finding in `findings/` carrying the same script in `poc_script_code`.
4. It records the trust boundary crossed and what an operator would actually gain — access, data, money, or control — not merely that the request succeeded.

Unconfirmed scripts do not live here. "Should work" is a finding lead, not an exploit.

## captured/

Juicy material: credentials, usernames, API keys, tokens, session artifacts, config dumps — proof of impact captured during authorized testing. Rules, no exceptions:

- **Never commit.** The engagement workspace `.gitignore` must exclude `Targets/*/captured/` before the first capture lands. Use the template's `.gitignore`.
- **Minimum proof.** Capture what demonstrates impact, nothing more. A password hash proves access; the full database does not.
- **Report and rotate.** Every captured secret goes in the final report with a rotation recommendation.
- **Encrypt at rest** when the engagement runs longer than a day or the workspace leaves your machine.

## Lifecycle

0. Ensure `captured/` is in the workspace root `.gitignore` (present by default in the engagement template) — before any capture can land.
1. Mode check passes → copy skeleton, rename to target slug.
2. During the scan, write each item to disk as it is confirmed, not at the end: the finding, the chain, and the captured-material list. Update the coverage row as its outcome is confirmed (`record_coverage`). A long run's context gets compacted and only files survive. On resume, read notes, threat model, coverage ledger, findings, attack-chain notes, captured-material list before retesting.
3. Before finish: every `exploits/` entry maps to a finding; the report lists `captured/` contents.
4. After the report: hand over per the engagement terms, then wipe `captured/` — the client rotates, you do not keep secrets.
