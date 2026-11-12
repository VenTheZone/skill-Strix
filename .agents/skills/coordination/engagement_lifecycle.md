---
name: engagement-lifecycle
description: End-to-end engagement workflow — authorize, recon, enumerate, exploit, escalate, capture, report, cleanup — with a gate at every phase boundary
---

# Engagement Lifecycle

The full arc of one engagement. Each phase has a gate: the gate fails, the phase does not start. Modes are defined in `scope_and_modes.md`; per-target output lives per `target_workflow.md`; shared scan state per `run_state.md`.

## Phase 0 — Authorize

Fill `scope.md` at the workspace root: mode, targets, exclusions, authorization reference, window.

- **WhiteHat**: targets come from the program's published scope file; program rules (rate limits, prohibited techniques) are copied into `scope.md`.
- **Engagement**: targets and techniques come from the signed authorization; the document reference and assessment window are recorded.
- **Lab**: targets are owned/lab/CTF infrastructure; state the ownership basis.

**Gate**: no filled `scope.md`, no recon. Discovered assets are not scope until the mode's rule admits them.

## Phase 1 — Recon

Map the attack surface: hosts, ports, apps, endpoints, technologies, trust boundaries. Passive first; active recon only as the mode allows.

Output: `notes/recon-<target>.md`, initial threat model per target (`save_threat_model`).

## Phase 2 — Enumerate

Turn the surface into a worklist. Every identified surface gets a coverage row (`record_coverage`) so the finish line is measurable.

Output: coverage ledger populated, target directories created per `target_workflow.md`.

## Phase 3 — Exploit

Prove findings. The bar is the Finding Records contract: required fields complete, `poc_description` and `poc_script_code` non-empty. Confirmed and runnable → `exploits/`; unconfirmed → stays a lead in `attack-chain/` notes.

**Gate**: a finding without a PoC does not enter the report as a finding — it enters as `needs_follow_up`.

## Phase 4 — Escalate & Chain

Combine proven findings into paths to impact: entry → access → next surface → impact. Update `attack-chain/` and amend the threat model (`amend_threat_model`).

## Phase 5 — Capture

Collect minimum proof of impact into `captured/`: the credential, the key, the session artifact — enough to demonstrate, never more. Rules in `target_workflow.md` apply without exception: never committed, encrypted at rest, listed for rotation.

## Phase 6 — Report

Write `reports/<target>-<date>.md` from the template in `reports/`:

1. **Executive summary** — what was at risk, what was proven, in plain language.
2. **Findings table** — severity per finding (severity bands per the closure skills), status, affected surface.
3. **Per-finding detail** — the finding file's content: description, impact, evidence, PoC, remediation.
4. **Captured secrets rotation list** — every secret in `captured/`, with a rotation recommendation.
5. **Coverage summary** — every ledger row: assessed, ruled out with evidence, or open follow-up.

**Gate**: every coverage row is `reported`, `no_issue_found`, `ruled_out`, or `not_applicable` — or the report names the `needs_follow_up` rows explicitly. An empty "we looked" is not a result.

## Phase 7 — Cleanup

- Revert every change made on targets (exploit cleanup steps from `exploits/` entries).
- Hand over the report per the engagement terms.
- Wipe `captured/` after handover — the client rotates, you do not keep secrets.
- Resolve or hand off every `needs_follow_up` row.

**Gate**: nothing you ran still runs; nothing you captured still sits in the workspace.
