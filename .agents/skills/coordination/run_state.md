---
name: run-state
description: Threat-model and coverage tool contracts, and closure-skill injection points for coordinated scans
---

# Run State

Two coordination tool families — threat model and coverage — maintain shared scan state across agents. Two closure skills are injected on every agent; two more are added for whitebox agents only. This file documents tool names, outcome enums, and injection points only.

## Threat Model

One threat model exists per scan. It is mirrored under the run directory and is readable by every agent.

### Tools

- `get_threat_model` — reads the current model body for the scan
- `save_threat_model` — writes the initial body; a second call replaces the body entirely
- `amend_threat_model` — appends new entries to the existing body without overwriting it

Agents that discover new attack surfaces during a scan should use `amend_threat_model` rather than `save_threat_model`. Use `save_threat_model` only to establish the initial model or to replace a stale one intentionally. Target-name normalization (identity snap) is described in `scope_and_modes.md`.

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
| `reported` | A finding was filed for this surface | No |
| `no_issue_found` | The surface was assessed; no vulnerability found | No |
| `ruled_out` | The surface was excluded from assessment | Yes |
| `not_applicable` | The surface does not apply to this target | Yes |
| `needs_follow_up` | Assessment is incomplete or inconclusive | Yes |

`ruled_out`, `not_applicable`, and `needs_follow_up` require an evidence string. Entries without evidence are rejected.

### Finish Behavior

`finish_scan` returns `success: true` even when coverage entries are missing or when rows carry `needs_follow_up`. When either condition is present, the result includes `coverage_warning`. The root agent should resolve or explicitly acknowledge uncovered surfaces before invoking `finish_scan`.

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
