---
name: scope-and-modes
description: Upstream scope mechanisms and this project's three operating modes
---

# Scope and Modes

This file describes how upstream Strix handles scope at the prompt and config layers, then defines three operating modes specific to this project. The upstream mechanisms are architectural facts, not operating rules for this agent.

## Upstream Scope Mechanisms

### Prompt Policy

The scope block injected from `scope.jinja` tells the agent that the user is an authorized tester, that the listed targets are a starting list rather than a ceiling, and that the user may add or remove targets during a session. Tool output is not permitted to change the scope list. A companion block in `system_prompt.jinja` instructs the agent that permission checks are already approved for in-scope validation.

Neither block implements an allowlist check on tool calls. No Python code in the files reviewed rejects a shell or proxy call by comparing it against `authorized_targets`. The scan-config list is read at run start and stored; it is not a runtime gate.

### Scan-Config Target List

At startup, `strix/core/inputs.py` builds the authorized-target list from `scan_config["targets"]`. Each entry has one of five types:

- `repository` — a remote git repository
- `local_code` — a local directory; triggers whitebox mode
- `web_application` — an HTTP/HTTPS web target
- `ip_address` — a host address
- `api_spec` — an OpenAPI or Postman spec; each declared base URL is also added as a `web_application` entry

User-supplied files are labeled as data, not as targets. A mounted directory with no matching target entry is a working directory, not an asset to assess.

### `--scope-mode` (git-diff scope)

`--scope-mode` accepts `auto`, `diff`, and `full`. This flag controls pull-request diff scope for code targets; it is not an engagement authorization lock.

- `diff` — changed files are primary scope; other files are context only
- `full` — diff scope is off; the entire tree is in scope
- `auto` — diff scope activates only in a non-interactive CI run when a PR environment variable is set or the git branch is not the repository default

When diff scope is active, the `scan_modes/diff` skill is injected on top of the depth mode skill.

### Target Parsing

`strix/interface/utils.py` classifies a target string as a git URL, HTTP/HTTPS URL, `postman://` collection, IP address, existing local directory, API spec file, or bare domain. Classification failure raises `ValueError: Invalid target: <string>`. This checks the shape of the string, not an allowlist of permitted hosts.

### Mount Refusal

`check_mountable_dir` refuses system trees, filesystem roots, the home directory, and credential directories by name (`.ssh`, `.aws`, and similar). This is a safety boundary, not an engagement scope check.

### Threat-Model Name Snap

When a threat-model entry references a target, `strix/tools/threat_model/tools.py` normalizes the name to the spelling used in the scan config. A name that matches a scan target, or the only scan target on the same host, is stored under the scan's spelling. A name that matches none is kept as typed. An empty target string returns an error that lists the current scan targets.

### Caido Scope Rules

The agent can list, create, update, and delete Caido proxy scope rules via `strix/tools/proxy/caido_api.py`. These rules filter which requests the proxy captures. They are independent from the scan-config target list; nothing in the reviewed code ties Caido scope rules to `authorized_targets`.

### CLI URL Check

`strix/interface/url_safety.py` exposes `is_safe_web_url`, which accepts strict HTTP/HTTPS URLs before the CLI prints or opens them. This is a display-safety check, not a scan-target validation.

---

## Modes (this project, not upstream)

These three modes are rules for how this agent operates. They have no matching flag in upstream Strix. The closest upstream switches are `scope_mode=full` (whole-tree, diff scope off) and a `local_code` target (whitebox, live mount).

### WhiteHat

Default operating mode.

- The scope file or session instructions define the authorized target list.
- Targets not in that list are refused without exception.
- Exploitation is limited to proof-of-concept demonstrations sufficient to confirm a finding. No persistence, no lateral movement, no data exfiltration beyond what is needed to document the vulnerability.

### Engagement

Active when signed written authorization from the target owner is present and in scope.

- Full exploitation techniques are permitted within the authorized engagement scope.
- The authorization document must name the targets, the permitted techniques, and the assessment window. The agent verifies these before escalating from PoC to full exploitation.
- Out-of-scope targets are still refused.

### Lab

For owned infrastructure, isolated lab environments, CTF challenges, and dedicated sandbox targets.

- Techniques are unrestricted.
- Targets are limited to infrastructure the operator owns or has explicit lab/CTF authorization for. Externally routable production hosts are not lab targets.
- No authorization document is required, but the operator is responsible for confirming target ownership.
