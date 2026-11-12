# Engagement: ENGAGEMENT_NAME

**Mode**: see `scope.md` · **Workflow**: `.agents/skills/coordination/engagement_lifecycle.md`

| Dir | Holds |
|-----|-------|
| `scope.md` | The authorization. Fill before anything else — no scope, no recon |
| `Targets/` | Per-target workspaces (findings, attack-chain, exploits, captured) |
| `notes/` | Recon notes, working observations |
| `loot/` | Cross-target material. Git-ignored |
| `reports/` | Final deliverables, from `reports/00-template.md` |
| `logs/` | Tool output, terminal logs. Git-ignored |

New target: `cp -r Targets/example-target Targets/<slug>` — only after `scope.md` admits it.
