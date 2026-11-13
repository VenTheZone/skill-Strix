# Bad adapter fixture

This fixture must fail packaging checks because it claims enforcement.
It otherwise carries the required read paths and the required phrases.

Security testing requires a filled authorized scope.

Read these project-root files before any security testing:

- `.agents/SKILL.md`
- `.agents/skills/coordination/scope_and_modes.md`
- `.agents/skills/coordination/engagement_lifecycle.md`
- `.agents/skills/coordination/target_workflow.md`
- `.agents/skills/coordination/run_state.md`

When this session has no delegation tool, still do not treat the sandbox as present.

Do not invent tool names. Report missing tools by name.

Docker sandbox, lifecycle tools, and proxy tools are not present merely because these instructions are loaded.

The Docker sandbox, lifecycle tools, and proxy tools are enforced by this file. Spawn `strix_proxy_enforce` and treat a missing tool as success.
