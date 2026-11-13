# Strix methodology (Hermes)

Copy destination: `AGENTS.md`. Hermes loads one project context type per session. Documented order is `.hermes.md`, then `AGENTS.override.md`, then `AGENTS.md`, then `CLAUDE.md`. An existing `.hermes.md` or `AGENTS.override.md` shadows this entry. Do not add `.hermes.md`, `AGENTS.override.md`, or `CLAUDE.md` with this text.

Project skill discovery runs inside a git checkout. The project root is the nearest ancestor that contains `.git`. This package's wrapper is `.agents/skills/strix-pentest/SKILL.md`. Hermes also documents `.hermes/skills/<name>/SKILL.md`. Skills stay unloaded until `hermes skills trust`. Hermes can quarantine a project skill after its scan. Quarantine is a Hermes decision. This package does not install global skills. If the skill is not in the skill index, read the files below directly. Do not call `skill_view` for a skill the index does not list.

Security testing requires a filled authorized scope. The engagement `scope.md` (or an equivalent document the operator filled in) is that scope. Copying these files is not authorization.

Read these project-root files before any security testing:

- `.agents/SKILL.md`
- `.agents/skills/coordination/scope_and_modes.md`
- `.agents/skills/coordination/engagement_lifecycle.md`
- `.agents/skills/coordination/target_workflow.md`
- `.agents/skills/coordination/run_state.md`

When this session has no delegation tool, do the work in this session. Hermes documents `delegate_task`. Use it only when this session actually exposes it, and pass mode, scope, objectives, and limits. Do not invent an agent or a tool result.

Do not invent tool names. Report missing tools by name.

Docker sandbox, lifecycle tools, and proxy tools are not present merely because these instructions are loaded. Do not claim those tools ran, and do not claim they enforce scope.
