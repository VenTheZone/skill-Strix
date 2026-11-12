# skill-Strix

Universal AI pentesting skill extracted from [usestrix/strix](https://github.com/usestrix/strix). Portable `.agents/` knowledge module for any agent harness.

## What

Strix is an open-source AI pentesting tool with multi-agent orchestration, skill injection, and sandboxed execution. This repo extracts its architecture into a single portable skill file any agent harness can use.

## Files

| File | Purpose |
|------|---------|
| `.agents/SKILL.md` | Universal skill — orchestration patterns, scan modes, tool integration, adapter table |
| `.agents/skills/` | 50+ skill files — playbooks, coordination (`scope_and_modes.md`, `run_state.md`, `target_workflow.md`), scan modes |
| `.agents/templates/engagement/` | Full engagement workspace skeleton — scope.md, Targets/, notes/, loot/, reports/, logs/ |
| `.agents/templates/new-engagement.sh` | Scaffolds an engagement: `new-engagement.sh <name> --mode whitehat\|engagement\|blackhat` |
| `README.md` | This file |
| `.gitignore` | Excludes local strix source clone from repo |

## What's Inside SKILL.md

| Section | Content |
|---------|---------|
| Agent Orchestration | Root/child hierarchy, lifecycle tools, coordinator state, crash handling |
| Skill System | YAML frontmatter format, 8 categories, resolution order, injection via XML blocks |
| Scan Modes | Quick (breadth), Standard (balanced), Deep (exhaustive) — phase breakdowns |
| Tool Integration | 30+ function tools, Caido proxy, Docker sandbox, error-as-result pattern |
| Config System | env > JSON > defaults, LiteLLM routing, retry policy, scan config schema |
| Adapter Patterns | Maps Strix concepts to Hermes, Claude Code, Codex CLI |
| Skill Writing Guide | Section pattern, frontmatter spec, what makes a good skill |
| Design Principles | 10 rules: root never tests, PoC or GTFO, errors as results, shared state |

## Harness Compatibility

| Strix Concept | Hermes | Claude Code | Codex CLI |
|---------------|--------|-------------|-----------|
| `create_agent` | `delegate_task` | `Task` tool | Sub-process |
| `send_message` | Inter-agent bus | Task result | stdout |
| `agent_finish` | Delegate complete | Task return | Exit code |
| `load_skill` | `skill_view(name)` | CLAUDE.md | System prompt |
| `think` | Step-back reasoning | Extended thinking | CoT prompt |
| `create_note` | `memory` tool | Write to file | Write to file |
| `create_todo` | `todo` tool | TodoWrite | Task list |
| Sandbox shell | `terminal` | `Bash` | `shell` |

## Usage

```bash
# Clone
git clone https://github.com/VenTheZone/skill-Strix.git

# Copy into your project
cp -r skill-Strix/.agents/ /your/project/.agents/

# Or read standalone as methodology reference
cat skill-Strix/.agents/SKILL.md
```

### Operating modes

`whitehat` follows a program's rules; `engagement` is a scoped assessment; `blackhat` (`black`) is adversary emulation — modeling a paid intruder, pricing the cheapest credible path to impact, engineering exploits against live authorized targets, and reporting what would have caught it. Black changes technique and priority, never the authorization boundary: every mode requires a filled `scope.md`, and a target outside it is refused. These are project prompt conventions, not upstream Strix flags or a tool-level enforcement mechanism.

## Source

- **Original repo**: https://github.com/usestrix/strix
- **License**: Apache 2.0
- **Docs**: https://docs.strix.ai
