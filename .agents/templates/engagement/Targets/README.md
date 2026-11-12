# Targets/

Per-target engagement workspaces. Rules and lifecycle: `.agents/skills/coordination/target_workflow.md`.

New target:

```bash
cp -r Targets/example-target Targets/<your-target-slug>
```

Create a target directory only after `scope.md` admits the target (WhiteHat: program scope; Engagement: signed authorization; Lab: owned/lab/CTF). `captured/` is already git-ignored by the workspace root `.gitignore`.
