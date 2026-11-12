# <Target> — Security Assessment Report

**Date**: · **Mode**: · **Scope ref**: link to scope.md

## 1. Executive summary

What was at risk, what was proven, plain language. Three sentences max.

## 2. Findings

| # | Severity | Finding | Surface | Status |
|---|----------|---------|---------|--------|
| 1 | | | | |

## 3. Detail

One section per finding — copy of `findings/<nn>-<slug>.md`: description, impact, evidence, PoC (`poc_description` + `poc_script_code`), remediation.

## 4. Captured secrets — rotation required

| Secret | Where captured | Rotation recommendation |
|--------|---------------|------------------------|

## 5. Coverage

Every ledger row: `reported` / `no_issue_found` / `ruled_out` (with evidence) / `not_applicable` / `needs_follow_up` (named explicitly).

## 6. BlackHat research results (when applicable)

**Threat actor emulated**: · **Stated objective**:

### Paths to impact — ranked by cost to attacker

Cheapest first. Cost = preconditions + steps + noise, not CVSS.

| Rank | Path | Precondition | Boundary crossed | Impact | Detection footprint |
|------|------|--------------|------------------|--------|---------------------|
| 1 | | | | | |

### What the actor takes first

The assets, accounts, or data an intruder would grab on arrival, and why. This is the list the owner should protect hardest.

### Research timeline

| Time | Action | Result |
|------|--------|--------|

### Exploit preconditions and live validation results

Per `exploits/` entry: what it needed, whether it ran, what it granted, and the artifact reference.

### Controls that held

Paths attempted and broken by a working control — with the control named. These are the owner's existing wins; do not omit them.

### Limitations

What was not tested, what was out of scope, and what remains a hypothesis rather than a result.

### Cleanup

Accounts created, records altered, artifacts planted, and their removal status. Nothing in this section may remain open at handover.

**Note.** The report body contains no workspace paths, agent or child names, proxy/exchange ids, or tool/harness names.

**Note.** If no findings are confirmed, say so in one sentence and point to the coverage ledger.

Delete this notice and rename to `<target>-<date>.md` when writing a real report.
