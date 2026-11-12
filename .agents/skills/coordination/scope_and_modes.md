---
name: scope-and-modes
description: Upstream scope mechanisms and this project's operating modes
---

# Scope and Modes

This file describes how upstream Strix handles scope at the prompt and config layers, then defines operating modes specific to this project. The upstream mechanisms are architectural facts, not operating rules for this agent.

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

These modes are rules for how this agent operates. They have no matching flag in upstream Strix. The closest upstream switches are `scope_mode=full` (whole-tree, diff scope off) and a `local_code` target (whitebox, live mount). Hat names are aliases, not changes to authorization gates:

| Hat | Mode | Approach | Targets |
|-----|------|----------|---------|
| White | WhiteHat | Program rules, PoC-limited | Program scope file |
| Gray | Engagement | Assessment and exploitation within authorization | Signed authorization |
| Black | BlackHat | Adversary emulation — exploit engineering and live validation against the cheapest path to impact | Explicitly authorized targets |

Operating mode, scope, and engagement limits take precedence over scan-depth and specialist playbooks. Pass the active mode, authorized scope, objectives, and limits to every delegated agent. A target without authorization or ownership is refused in every mode, including Black. A discovered asset, credential, or access path does not itself expand scope. Black sharpens *technique and intent* inside the authorized boundary; it never widens the boundary.

### WhiteHat (White)

Default operating mode.

- The scope file or session instructions define the authorized target list.
- Targets not in that list are refused without exception.
- Exploitation is limited to proof-of-concept demonstrations sufficient to confirm a finding. No persistence, no lateral movement, no data exfiltration beyond what is needed to document the vulnerability.

### Engagement (Gray)

Active when signed written authorization from the target owner is present and in scope.

- Full exploitation techniques are permitted within the authorized engagement scope.
- The authorization document must name the targets, the permitted techniques, and the assessment window. The agent verifies these before escalating from PoC to full exploitation.
- Out-of-scope targets are still refused.

### BlackHat (Black)

Adversary emulation. Black is not "Engagement with more payloads" — it changes the question from *what is broken here?* to *what would a paid intruder take, and what is the cheapest path to it?*

Authorization is unchanged from the sections above: `scope.md` names the targets and the techniques, and nothing outside it is touched. Inside that boundary the work is deliberately sharper than White or Engagement — full exploitation, exploit engineering, live validation, and chaining across the whole authorized estate.

#### Actor model

Assume an operator paid for impact, not for findings. That changes priorities:

- **One request that pays beats a six-step chain that pays.** Prefer the shortest path to the objective.
- **Identity material first.** Sessions, tokens, API keys, OAuth grants, service accounts, CI/CD secrets, signing keys. Credentials convert to access with no exploit at all — always price that path before hunting a memory bug.
- **Pre-auth over authenticated. Low-priv to admin over admin to root.** Cheapest precondition wins.
- **Quiet over loud.** A path that trips an alert is worth less than a slower path that does not. Note the noise each technique generates.
- **Reuse what already works.** Third parties, SSO, shared tenancy, build pipelines, support tooling, backups, and recovery flows are already trusted — that is the point of them.
- **Abandon unreachable preconditions.** A path needing a foothold the actor cannot realistically get is a hypothesis, not a finding.

#### Kill-chain emphasis

Weight effort toward where money and control actually move, not toward whichever CVE is easiest to run:

1. **Identity and session issuance** — login, reset, MFA enrolment/reset, token minting and lifetime, session fixation, refresh rotation, impersonation and support-override paths.
2. **Cloud control plane and IAM** — role assumption, trust policies, instance metadata, over-broad service principals, key custody.
3. **Money and entitlement flows** — payments, refunds, credits, quotas, trials, discount codes, referral loops, seat and plan boundaries, race conditions on balance-changing operations.
4. **Tenant isolation** — cross-tenant read and write, shared caches and queues, IDOR-shaped object access at scale rather than one object.
5. **Supply chain and dependency trust** — CI/CD secrets, artifact publishing rights, install hooks, IaC drift, build-cache poisoning.
6. **Recovery paths** — password reset, MFA reset, backup restore, data export. Recovery is usually weaker than the front door.

#### Viability test

A path enters `attack-chain/` only when all four are named:

1. **Precondition** — the foothold, account, key, or open surface it needs, and whether that precondition is realistically obtainable by this actor.
2. **Boundary crossed** — the specific trust boundary (user→admin, tenant→tenant, internet→internal, build→production).
3. **Impact** — whose data, whose money, whose control plane, and how much of it.
4. **Detection footprint** — what the activity looks like in logs, and whether an existing control would plausibly have stopped it.

A path that fails (4) is not a finding — it is a control that works. Record it as `ruled_out` with the control named, per `run_state.md`.

#### Proof bar

Inside authorized scope, exploitation is *executed*, not described:

- The PoC reproduces from a clean starting state, twice, and states preconditions, expected result, and cleanup.
- `poc_script_code` is a runnable artifact, not prose about one, and it lives in `findings/<nn>-<slug>.md`.
- Preconditions, blast radius, and detection footprint are recorded in the finding alongside the PoC.
- Capture is minimum proof only, under the rules in `target_workflow.md`.
- HTTP-validated findings must carry the proving and baseline proxy exchange ids (`http_exchange_ids`), so evidence is tied to captured traffic, not paraphrase.

Do not stop at "the endpoint returned 200." Establish what the response actually grants: which object, whose tenant, which privilege, how much data, and for how long. A finding that demonstrates a status code has not demonstrated impact.

#### Stop conditions

Stop and contact the `scope.md` emergency contact on: unexpected impact, degradation of a live service, data beyond the agreed threshold, credential or key material for a system not named in `scope.md`, or any pivot out of scope. Stopping is not a failure of the test — an unreported impact is.

#### What Black is not

- Not permission to exceed scope. Authorization still gates every target, as it does in every other mode.
- Not persistence for its own sake, and not denial of service. Neither produces a report the owner can act on.
- Not a list of theoretical attack surfaces. Hypotheses stay in `attack-chain/` notes and are labelled as hypotheses.
- Not a competition for technique count. The deliverable is the cheapest credible path to impact, plus what would have caught it.
