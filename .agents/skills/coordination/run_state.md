---
name: run-state
description: Threat-model and coverage tool contracts, and closure-skill injection points for coordinated scans
---

# Run State

Two coordination tool families — threat model and coverage — maintain shared scan state across agents. Two closure skills are injected on every agent; two more are added for whitebox agents only. This file documents the threat-model contract, tool names, outcome enums, and injection points.

## Threat Model

One threat model exists **per target per scan**, and it is kept current. It is kept in memory and mirrored to the run directory, so a resumed scan reloads it; other scans never read it. Every agent can read it.

A model has four sections. A model missing a section is incomplete — complete it before relying on it.

- **Overview**
- **Trust Boundaries and Assumptions**
- **Attack Surface and Attacker Stories**
- **Severity Calibration** — rating for this target; band rules stay in the injected `analysis/severity_calibration` skill

Black-box order: recon first, then write the model from what actually answered. Mark each claim inferred or observed. Do not wait for a perfect picture before testing.

Amend, don't overwrite. Later agents amend the existing model with new evidence. The root reads amendments before writing the report.

### Tools

- `get_threat_model(target)` — reads the current model body for the named target
- `save_threat_model(target, content)` — writes the initial body for that target; a second call replaces the body **and clears all amendments**
- `amend_threat_model(target, addendum)` — appends a new entry to the existing body without overwriting it

Agents that discover new attack surfaces during a scan should use `amend_threat_model` rather than `save_threat_model`. Use `save_threat_model` only to establish the initial model or to fold accumulated amendments back in intentionally. Target-name normalization (identity snap) is described in `scope_and_modes.md`.

---

## Coverage

Each attack surface identified during a scan should have a coverage record before `finish_scan` is called.

### Tools

- `record_coverage` — creates a new coverage entry for a surface
- `update_coverage` — changes the outcome or evidence on an existing entry
- `list_coverage` — returns all coverage entries for the current scan

### Outcomes

| Outcome | Meaning | Evidence required |
|---|---|---|
| `open` | Surface enumerated, not yet tested | No |
| `reported` | A finding was filed for this surface | No |
| `no_issue_found` | The surface was assessed; no vulnerability found | No |
| `ruled_out` | A specific candidate was disproved by counterevidence — the evidence must name the control that makes it safe, at a location, and confirm it runs on every attacker-reachable path | Yes |
| `not_applicable` | This risk cannot apply here (e.g. no XML parsing on a surface, so no XXE); evidence must explain why | Yes |
| `needs_follow_up` | Plausible but unresolved: the candidate could not be confirmed and no ruling-out control could be named; evidence must name the gap (missing credentials, unreachable service, unconfirmed reachability) | Yes |

`ruled_out`, `not_applicable`, and `needs_follow_up` require an evidence string. Entries without evidence are rejected. `open` is not a closure outcome, so the closure set stays the other five.

### Finish Behavior

`finish_scan` returns `success: true` and completes even when coverage entries are missing or when rows carry `needs_follow_up`. When either condition is present, the result includes `coverage_warning`. The root holds the report under the stop-worklist gate in `root_agent.md` Completion.

---

## Closure Skills

Four analysis skills are injected at agent construction time. They are not user-selectable; they are added on top of the caller-requested skill set.

### Every Agent

- `analysis/counterevidence` — three closure states an agent must reach before filing a finding
- `analysis/severity_calibration` — severity bands and rating rules

### Whitebox Agents Only

Whitebox mode is active when at least one scan target has type `local_code`.

- `analysis/fix_verification` — fix gates that a reported fix must satisfy
- `analysis/source_aware_discovery` — source-code discovery patterns for whitebox targets
