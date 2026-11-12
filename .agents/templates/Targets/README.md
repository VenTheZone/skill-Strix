# Targets/

Per-target engagement workspaces. Rules and lifecycle: `.agents/skills/coordination/target_workflow.md`.

Setup:

```bash
cp -r .agents/templates/Targets/ Targets/
mv Targets/example-target Targets/<your-target-slug>
cat .agents/templates/Targets/.gitignore >> .gitignore
```

Create a target directory only after the active mode authorizes the target (WhiteHat: scope file; Engagement: signed authorization; Lab: owned/lab/CTF).
