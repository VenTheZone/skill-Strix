# Strix methodology (Codex)

Copy destination: `AGENTS.md`. Codex loads at most one instruction file per directory: `AGENTS.override.md`, then `AGENTS.md`, then configured fallback names. Nested files are concatenated from the repo root down to the working directory. Do not repeat this text in a parent `AGENTS.md`.

OpenAI documents repo-local skills at `.agents/skills/<name>/SKILL.md`. That is the wrapper `.agents/skills/strix-pentest/SKILL.md`. `.agents/SKILL.md` is not that layout. If `strix-pentest` is not available as a skill, read the files below anyway.

Security testing requires a filled authorized scope. The engagement `scope.md` (or an equivalent document the operator filled in) is that scope. Copying these files is not authorization.

Read these project-root files before any security testing:

- `.agents/SKILL.md`
- `.agents/skills/coordination/scope_and_modes.md`
- `.agents/skills/coordination/engagement_lifecycle.md`
- `.agents/skills/coordination/target_workflow.md`
- `.agents/skills/coordination/run_state.md`

When this session has no delegation tool, do the work in this session. Use a Codex subagent only when this session actually exposes one, and pass mode, scope, objectives, and limits. Do not invent an agent or a tool result.

Do not invent tool names. Report missing tools by name.

Docker sandbox, lifecycle tools, and proxy tools are not present merely because these instructions are loaded. Do not claim those tools ran, and do not claim they enforce scope.
