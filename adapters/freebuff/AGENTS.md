# Strix methodology (Freebuff)

Copy destination: `AGENTS.md`. An agent read Freebuff source at commit `78ee2cf53f08048c4be89fbb7a63098ff2f50b66`: `common/src/constants/knowledge.ts` lists `AGENTS.md` then `CLAUDE.md`; `sdk/src/skills/load-skills.ts` loads `.claude/skills/<name>/SKILL.md` then `.agents/skills/<name>/SKILL.md`; `sdk/CHANGELOG.md` records that order. `.agents/SKILL.md` is not auto-discovered. Do not also install `CLAUDE.md` with this same body. Do not copy the wrapper into `.claude/skills/` as well: that directory is also searched.

The discovery file is `.agents/skills/strix-pentest/SKILL.md`. If it is not listed, read the files below directly.

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
