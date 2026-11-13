# Strix methodology (OpenCode)

Copy destination: `AGENTS.md` at the project root. Do not rely on `.opencode` for instructions or for this skill. The current instructions doc says OpenCode recognizes `AGENTS.md` only (not `CLAUDE.md`). An older rules page still mentions `CLAUDE.md`; do not use that as the install path.

The skills doc lists `.agents/skills/<name>/SKILL.md` as a project compatibility path. This package's wrapper is `.agents/skills/strix-pentest/SKILL.md`. `.opencode/skills` is also documented. This repository gitignores `.opencode/`, so the shared tree does not put the skill there. If the skill tool does not list `strix-pentest`, read the files below anyway.

Security testing requires a filled authorized scope. The engagement `scope.md` (or an equivalent document the operator filled in) is that scope. Copying these files is not authorization.

Read these project-root files before any security testing:

- `.agents/SKILL.md`
- `.agents/skills/coordination/scope_and_modes.md`
- `.agents/skills/coordination/engagement_lifecycle.md`
- `.agents/skills/coordination/target_workflow.md`
- `.agents/skills/coordination/run_state.md`

When this session has no delegation tool, do the work in this session. OpenCode documents a `skill` tool for loading `SKILL.md` files. That tool loads instructions. It is not a child agent and it is not a sandbox. Do not invent an agent or a tool result.

Do not invent tool names. Report missing tools by name.

Docker sandbox, lifecycle tools, and proxy tools are not present merely because these instructions are loaded. Do not claim those tools ran, and do not claim they enforce scope.
