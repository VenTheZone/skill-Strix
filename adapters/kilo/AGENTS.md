# Strix methodology (Kilo Code)

Copy destination: `AGENTS.md`. Kilo documents `AGENTS.md` (and `AGENT.md` as a fallback) and also recognizes `CLAUDE.md` and `CONTEXT.md`. Install this file only. Do not also install `CLAUDE.md` with this same body.

`.agents/skills/<name>/SKILL.md` is loaded by default, including `.agents/skills/strix-pentest/SKILL.md`. `.kilo/skills/` is the native project path. Do not copy the wrapper there as well. `.claude/skills/` loads when Claude compatibility is enabled, so do not copy the wrapper there either. If `strix-pentest` is not listed, read the files below directly. Set `KILO_DISABLE_EXTERNAL_SKILLS=true` only when you intend to turn `.agents/skills/` off; this package then will not be discovered as a skill.

Security testing requires a filled authorized scope. The engagement `scope.md` (or an equivalent document the operator filled in) is that scope. Copying these files is not authorization.

Read these project-root files before any security testing:

- `.agents/SKILL.md`
- `.agents/skills/coordination/scope_and_modes.md`
- `.agents/skills/coordination/engagement_lifecycle.md`
- `.agents/skills/coordination/target_workflow.md`
- `.agents/skills/coordination/run_state.md`

When this session has no delegation tool, do the work in this session. Use a delegation tool only when this session actually exposes one, and pass mode, scope, objectives, and limits. Do not invent an agent or a tool result.

Do not invent tool names. Report missing tools by name.

Docker sandbox, lifecycle tools, and proxy tools are not present merely because these instructions are loaded. Do not claim those tools ran, and do not claim they enforce scope.
