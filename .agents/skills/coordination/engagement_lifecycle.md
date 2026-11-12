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
- **BlackHat**: record authorization, targets and identities, permitted techniques, limits, window, contact, and stop conditions. Resolve missing details with the operator before testing.
- **BlackHat**: also record the *objective* and the *actor* being emulated — what the owner most fears losing (tenant data, money movement, production control plane, signing keys) and which threat actor is the yardstick. Objectives are not prefilled by the assessment; they are agreed with the owner, and they set the priority order for every later phase.

**Gate**: no filled `scope.md`, no recon. Discovered assets are not scope until the mode's rule admits them.

**Resume.** On a resumed session, read notes, the threat model, the coverage ledger, and findings before retesting anything.

## Phase 1 — Recon

Map the attack surface: hosts, ports, apps, endpoints, technologies, trust boundaries. Passive first; active recon only as the mode allows.

Output: `notes/recon-<target>.md`, initial threat model per target (`save_threat_model`).

**BlackHat emphasis**: recon is where the adversary's advantage is built. Prioritize the estate map over the endpoint list — owned domains and their forgotten siblings, cloud account boundaries, SSO and identity providers, third parties with trust, CI/CD and artifact stores, admin and internal-only surfaces, employee and support tooling. Every asset discovered but not authorized is logged as an out-of-scope observation, without being touched.

## Phase 2 — Enumerate

Turn the surface into a worklist. Every identified surface gets a coverage row (`record_coverage`) so the finish line is measurable.

Output: coverage ledger populated, target directories created per `target_workflow.md`.

**BlackHat emphasis**: order the worklist by expected return for the actor in `scope.md`, not by scanner severity. Identity and session issuance, cloud/IAM trust, money movement, tenant boundaries, and recovery flows outrank an isolated medium-severity injection. A surface that is reachable but yields nothing the actor wants is a `not_applicable` row with the reason stated, not a silent skip.

## Phase 3 — Exploit

Prove findings. In BlackHat mode, develop and refine reproducible exploit artifacts and validate against live in-scope targets where permitted. The bar is the Finding Records contract: required fields complete, `poc_description` and `poc_script_code` non-empty. Confirmed and runnable → `exploits/`; unconfirmed → stays a lead in `attack-chain/` notes.

**BlackHat emphasis**: exploit engineering, not payload substitution. When a standard payload fails, the interesting question is *why* — the parser, the normalization step, the allowlist, the framework version — and the next attempt targets that specific mechanism. Reaching for a heavier tool before understanding the block is wasted effort. Record what the control did, because that is both the bypass path and the remediation input.

**Gate**: a finding without a PoC does not enter the report as a finding — it enters as `needs_follow_up`.

## Phase 4 — Escalate & Chain

Combine proven findings into paths to impact: entry → access → next surface → impact. Update `attack-chain/` and amend the threat model (`amend_threat_model`). For BlackHat, continue only along authorized paths and techniques, recording timestamps and results; stop and contact the owner on unexpected impact or an out-of-scope pivot.

## Phase 5 — Capture

Collect minimum proof of impact into `captured/`: the credential, the key, the session artifact — enough to demonstrate, never more. Rules in `target_workflow.md` apply without exception: never committed, encrypted at rest, listed for rotation.

## Phase 6 — Report

**Finish preflight.** The root clears this list before writing the report:

1. No report while any child is still running, waiting, or paused. Stop it first and record what it did not finish.
2. In non-quick mode, try each plausibly related combination of confirmed findings as a chain. State it unrelated, with reason, only after that try, or in quick mode or wind-down.
3. An assigned skill class with zero coverage rows is unexamined, not clean.
4. Zero confirmed findings is stated as a sentence plus the coverage ledger — never an implied clean bill.

The preflight also requires the root's "Before you stop" worklist in `root_agent.md` to be empty or explicit, covering open proof gaps and children that returned without a list.

Write `reports/<target>-<date>.md` from the template in `reports/`:

1. **Executive summary** — what was at risk, what was proven, in plain language.
2. **Findings table** — severity per finding (severity bands per the closure skills), status, affected surface.
3. **Per-finding detail** — the finding file's content: description, impact, evidence, PoC, remediation.
4. **Captured secrets rotation list** — every secret in `captured/`, with a rotation recommendation.
5. **Coverage summary** — every ledger row: assessed, ruled out with evidence, or open follow-up.
6. **BlackHat, when applicable** — research timeline, exploit preconditions and results, attack paths, limitations, and cleanup. Written for the defender: for each path, the cheapest entry point, what the actor would take first, the detection footprint, and the control that would have broken the chain. Rank paths by cost-to-attacker, not by severity score — that ranking is what the owner budgets against.

**Gate**: every coverage row is `reported`, `no_issue_found`, `ruled_out`, or `not_applicable` — or the report names the `needs_follow_up` rows explicitly. An empty "we looked" is not a result.

## Phase 7 — Cleanup

- Revert every change made on targets (exploit cleanup steps from `exploits/` entries).
- Hand over the report per the engagement terms.
- Wipe `captured/` after handover — the client rotates, you do not keep secrets.
- Resolve or hand off every `needs_follow_up` row.

**Gate**: nothing you ran still runs; nothing you captured still sits in the workspace.
