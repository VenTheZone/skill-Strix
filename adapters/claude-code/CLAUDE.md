# Strix methodology (Claude Code)

Copy destination: `CLAUDE.md` at the project root. Use that documented memory file.

Documented skill path: `.claude/skills/strix-pentest/SKILL.md`. The shared tree ships the wrapper at `.agents/skills/strix-pentest/SKILL.md`. Copy that directory to `.claude/skills/strix-pentest/` for Claude Code. If `strix-pentest` is not listed, read the files below anyway. `.agents/SKILL.md` is not a Claude skill path.

Do not also install an `AGENTS.md` that repeats this text.

Security testing requires a filled authorized scope. The engagement `scope.md` (or an equivalent document the operator filled in) is that scope. Copying these files is not authorization.

Read these project-root files before any security testing:

- `.agents/SKILL.md`
- `.agents/skills/coordination/scope_and_modes.md`
- `.agents/skills/coordination/engagement_lifecycle.md`
- `.agents/skills/coordination/target_workflow.md`
- `.agents/skills/coordination/run_state.md`

When this session has no delegation tool, do the work in this session. Claude Code documents a Task tool for subagents. Use it only when this session actually exposes it, and pass mode, scope, objectives, and limits. Do not invent an agent or a tool result.

Do not invent tool names. Report missing tools by name.

Docker sandbox, lifecycle tools, and proxy tools are not present merely because these instructions are loaded. Do not claim those tools ran, and do not claim they enforce scope.
