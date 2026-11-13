# Strix methodology (pi)

Copy destination: `AGENTS.md` only. Current pi source (`loadContextFileFromDir`) keeps one context file per directory, in order `AGENTS.override.md`, `AGENTS.md`, `AGENTS.MD`, `CLAUDE.md`, `CLAUDE.MD`. It then concatenates the agent-directory file with the ancestor chain. Same path is deduped. Do not copy this text into `CLAUDE.md`, a parent `AGENTS.md`, or `~/.pi/agent` as well: avoid duplicate loading.

Skills load from `.agents/skills/strix-pentest/SKILL.md`. Do not also install that directory under `.pi/skills/`. Context files load without project trust. Project skills are protected by project trust. If the skill is not listed, read the files below with the read tool.

Documented default tools include `read`, `write`, `edit`, and `bash`. No delegation tool is part of that default set.

Security testing requires a filled authorized scope. The engagement `scope.md` (or an equivalent document the operator filled in) is that scope. Copying these files is not authorization.

Read these project-root files before any security testing:

- `.agents/SKILL.md`
- `.agents/skills/coordination/scope_and_modes.md`
- `.agents/skills/coordination/engagement_lifecycle.md`
- `.agents/skills/coordination/target_workflow.md`
- `.agents/skills/coordination/run_state.md`

When this session has no delegation tool, do the work in this session. Do not invent an agent or a tool result.

Do not invent tool names. Report missing tools by name.

Docker sandbox, lifecycle tools, and proxy tools are not present merely because these instructions are loaded. Do not claim those tools ran, and do not claim they enforce scope.
