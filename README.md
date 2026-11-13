# skill-Strix

Markdown methodology extracted from [usestrix/strix](https://github.com/usestrix/strix). The canonical text is `.agents/SKILL.md` plus the playbooks under `.agents/skills/`. Harness files in `adapters/` are copy sources. They point at that text. They do not restate it.

Nothing in this repository was runtime-tested inside Claude Code, Codex, OpenCode, pi, Hermes, Freebuff, or Kilo Code. Harness paths below are docs-verified, except Freebuff. Freebuff paths are an agent source read of commit `78ee2cf53f08048c4be89fbb7a63098ff2f50b66`.

Copying this tree is not authorization to test a target. Security testing requires a filled authorized scope. These files do not create a sandbox, a lifecycle tool, or a proxy, and they do not enforce scope.

## Files

| Path | Role |
|------|------|
| `.agents/SKILL.md` | Canonical methodology. Not an auto-discovered skill file. |
| `.agents/skills/<category>/*.md` | Playbooks. Read by path. Not moved. |
| `.agents/skills/strix-pentest/SKILL.md` | Thin wrapper with `name: strix-pentest`. Points at the canonical file, `scope_and_modes.md`, and the lifecycle files. |
| `.agents/templates/engagement/` | Engagement skeleton. |
| `.agents/templates/new-engagement.sh` | `new-engagement.sh <name> --mode whitehat\|engagement\|blackhat` |
| `adapters/<harness>/` | One copy source per harness, using that harness's destination filename. |
| `AGENTS.md`, `CLAUDE.md` | Maintainer rules for this checkout. Not the pentest adapter. |
| `LICENSE`, `NOTICE` | Apache 2.0 attribution. Keep both with any copy you redistribute. |

Section 6 of `.agents/SKILL.md` maps upstream Strix concept names onto other harnesses. Those names are documentation of Strix. They are not a claim that the harness has those tools.

## Operating modes

`whitehat` follows a program's rules. `engagement` is a scoped assessment. `blackhat` (`black`) is adversary emulation: model a paid intruder, price the cheapest credible path to impact, engineer exploits against live authorized targets, and report what would have caught it. Black changes technique and priority, never the authorization boundary. Every mode requires a filled `scope.md`. A target outside it is refused. These are project prompt conventions, not upstream Strix flags and not a tool-level gate. Modes apply to an engagement that already has authorization. They are not a reason to test this repository.

## Install

Run these from a checkout of this repository. Edit `DEST` and `HARNESS`, then run one subshell whole. `DEST` must already be a directory and must not be a symlink. `HARNESS=codex` is the example. The `case` selects one harness: `claude-code` writes `CLAUDE.md.example`; every other name writes `AGENTS.md.example`. Do not install both `AGENTS.md` and `CLAUDE.md`.

`AGENTS.md.example` and `CLAUDE.md.example` are inactive until you merge one by hand, or rename it with the subshell below. Harnesses do not load the `.example` name. Copy the shared tree first, then `LICENSE` and `NOTICE`. If `$DEST/.agents` already exists, including as a symlink, stop. Merge the shared tree by hand. This copy does not merge or replace it.

```bash
(
  set -eu
  DEST=/path/to/project
  HARNESS=codex
  if [ ! -d "$DEST" ] || [ -L "$DEST" ]; then
    printf '%s\n' "DEST must be an existing directory and not a symlink: $DEST" >&2
    exit 1
  fi
  if [ -e "$DEST/.agents" ] || [ -L "$DEST/.agents" ]; then
    printf '%s\n' "$DEST/.agents already exists. Merge the shared tree by hand. This copy does not merge or replace it." >&2
    exit 1
  fi
  cp -a .agents "$DEST/.agents"
  if [ -e "$DEST/.agents/LICENSE" ] || [ -L "$DEST/.agents/LICENSE" ] \
    || [ -e "$DEST/.agents/NOTICE" ] || [ -L "$DEST/.agents/NOTICE" ]; then
    printf '%s\n' "LICENSE or NOTICE already exists under $DEST/.agents. Merge by hand." >&2
    exit 1
  fi
  cp -a LICENSE NOTICE "$DEST/.agents/"
  case "$HARNESS" in
    claude-code)
      if [ -e "$DEST/CLAUDE.md.example" ] || [ -L "$DEST/CLAUDE.md.example" ]; then
        printf '%s\n' "$DEST/CLAUDE.md.example already exists. Merge by hand." >&2
        exit 1
      fi
      cp -a adapters/claude-code/CLAUDE.md "$DEST/CLAUDE.md.example"
      ;;
    codex|opencode|pi|hermes|freebuff|kilo)
      if [ -e "$DEST/AGENTS.md.example" ] || [ -L "$DEST/AGENTS.md.example" ]; then
        printf '%s\n' "$DEST/AGENTS.md.example already exists. Merge by hand." >&2
        exit 1
      fi
      cp -a "adapters/${HARNESS}/AGENTS.md" "$DEST/AGENTS.md.example"
      ;;
    *)
      printf '%s\n' "Unknown harness: $HARNESS" >&2
      exit 1
      ;;
  esac
)
```

Claude Code only, after the shared tree is in place. Set `HARNESS=claude-code`. This snippet copies the wrapper to `.claude/skills/strix-pentest/`. The other harnesses in this package use `.agents/skills/strix-pentest/SKILL.md`. Do not use this copy for them.

```bash
(
  set -eu
  DEST=/path/to/project
  HARNESS=claude-code
  [ "$HARNESS" = claude-code ]
  if [ ! -d "$DEST" ] || [ -L "$DEST" ]; then
    printf '%s\n' "DEST must be an existing directory and not a symlink: $DEST" >&2
    exit 1
  fi
  if [ ! -d "$DEST/.agents/skills/strix-pentest" ] || [ -L "$DEST/.agents/skills/strix-pentest" ]; then
    printf '%s\n' "Missing $DEST/.agents/skills/strix-pentest. Copy the shared tree first." >&2
    exit 1
  fi
  if [ -L "$DEST/.claude" ] || [ -L "$DEST/.claude/skills" ]; then
    printf '%s\n' "Refusing to write through a symlink. Merge by hand." >&2
    exit 1
  fi
  if [ -e "$DEST/.claude/skills/strix-pentest" ] || [ -L "$DEST/.claude/skills/strix-pentest" ]; then
    printf '%s\n' "$DEST/.claude/skills/strix-pentest already exists. Merge by hand." >&2
    exit 1
  fi
  mkdir -p "$DEST/.claude/skills"
  cp -a "$DEST/.agents/skills/strix-pentest" "$DEST/.claude/skills/"
)
```

Rename one `.example` onto the harness filename only when that destination is absent. An existing file or symlink—even a dangling symlink—blocks the rename; merge the example by hand instead.

```bash
(
  set -eu
  DEST=/path/to/project
  HARNESS=codex
  if [ ! -d "$DEST" ] || [ -L "$DEST" ]; then
    printf '%s\n' "DEST must be an existing directory and not a symlink: $DEST" >&2
    exit 1
  fi
  case "$HARNESS" in
    claude-code)
      [ -f "$DEST/CLAUDE.md.example" ]
      if [ -e "$DEST/CLAUDE.md" ] || [ -L "$DEST/CLAUDE.md" ]; then
        printf '%s\n' "$DEST/CLAUDE.md already exists. Merge $DEST/CLAUDE.md.example by hand." >&2
        exit 1
      fi
      mv "$DEST/CLAUDE.md.example" "$DEST/CLAUDE.md"
      ;;
    codex|opencode|pi|hermes|freebuff|kilo)
      [ -f "$DEST/AGENTS.md.example" ]
      if [ -e "$DEST/AGENTS.md" ] || [ -L "$DEST/AGENTS.md" ]; then
        printf '%s\n' "$DEST/AGENTS.md already exists. Merge $DEST/AGENTS.md.example by hand." >&2
        exit 1
      fi
      mv "$DEST/AGENTS.md.example" "$DEST/AGENTS.md"
      ;;
    *)
      printf '%s\n' "Unknown harness: $HARNESS" >&2
      exit 1
      ;;
  esac
)
```

Keep `LICENSE` and `NOTICE` next to any redistributed copy. The install subshell places them in `$DEST/.agents/`. Do not strip them.

## Harness matrix

| Harness | Instruction file | Skill file this package uses | Do not |
|---------|------------------|-------------------------------|--------|
| Claude Code | `CLAUDE.md` | Copy wrapper to `.claude/skills/strix-pentest/SKILL.md` | Also install `AGENTS.md` with this body, or treat `.agents/SKILL.md` as the skill path. |
| Codex | `AGENTS.md` | `.agents/skills/strix-pentest/SKILL.md` | Repeat the text in a parent `AGENTS.md`. Codex concatenates the chain and keeps one file per directory. |
| OpenCode | `AGENTS.md` | `.agents/skills/strix-pentest/SKILL.md` | Do not rely on `.opencode`. This repo gitignores it. Current instructions doc does not use `CLAUDE.md`. |
| pi | `AGENTS.md` | `.agents/skills/strix-pentest/SKILL.md` | Also install `CLAUDE.md` or a parent copy. One file per directory, then the ancestor chain is concatenated. avoid duplicate loading. Do not also copy the wrapper into `.pi/skills/`. |
| Hermes | `AGENTS.md` | `.agents/skills/strix-pentest/SKILL.md` inside a git checkout, after `hermes skills trust` | Expect skill discovery outside a git checkout. Ignore an existing `.hermes.md` or `AGENTS.override.md`; either shadows this entry. Install global skills from this package. |
| Freebuff | `AGENTS.md` | `.agents/skills/strix-pentest/SKILL.md` | Also install `CLAUDE.md` or a second wrapper under `.claude/skills/`. `.agents/SKILL.md` is not auto-discovered. |
| Kilo Code | `AGENTS.md` | `.agents/skills/strix-pentest/SKILL.md` | Also install `CLAUDE.md`, or a second copy under `.kilo/skills/` or `.claude/skills/`. |

If the skill is not listed, the instruction file still tells the agent to read `.agents/SKILL.md`, `scope_and_modes.md`, `engagement_lifecycle.md`, `target_workflow.md`, and `run_state.md`. When the session has no delegation tool, the agent stays in that session. Missing tools are reported. They are not invented, and they are not treated as success.

## Sources

Docs-verified unless the Freebuff note says otherwise. Not runtime-tested.

**Claude Code**

- Memory file `CLAUDE.md`: https://code.claude.com/docs/en/claude-md
- Skills at `.claude/skills/<name>/SKILL.md`: https://code.claude.com/docs/en/skills

**Codex**

- `AGENTS.md` discovery, one file per directory, concatenated from the root down: https://developers.openai.com/codex/guides/agents-md
- Repo-local `.agents/skills/`: https://developers.openai.com/blog/skills-agents-sdk
- Migration table `.agents/skills/*/SKILL.md`: https://developers.openai.com/cookbook/examples/agents_sdk/migrate-from-claude-agent-sdk/readme

**OpenCode**

- Instructions, `AGENTS.md`: https://opencode.ai/docs/instructions/
- Skills, including `.agents/skills`: https://opencode.ai/docs/skills/

**pi**

- Context files: https://pi.dev/docs/latest/configuration
- Skills: https://pi.dev/docs/latest/skills

**Hermes**

- Context files. One project type per session: `.hermes.md`, then `AGENTS.override.md`, then `AGENTS.md`, then `CLAUDE.md`: https://hermes-agent.nousresearch.com/docs/user-guide/features/context-files
- Project skills when the session starts inside a git checkout. Project root is the nearest ancestor that contains `.git`. Paths: `.hermes/skills/<name>/SKILL.md` and `.agents/skills/<name>/SKILL.md`, after `hermes skills trust`: https://hermes-agent.nousresearch.com/docs/user-guide/features/skills

**Freebuff**

Agent source read of https://github.com/CodebuffAI/freebuff at commit `78ee2cf53f08048c4be89fbb7a63098ff2f50b66`. Not runtime-tested here.

- `common/src/constants/knowledge.ts` lists `AGENTS.md`, then `CLAUDE.md`: https://github.com/CodebuffAI/freebuff/blob/78ee2cf53f08048c4be89fbb7a63098ff2f50b66/common/src/constants/knowledge.ts
- `sdk/src/skills/load-skills.ts` loads project `.claude/skills/<name>/SKILL.md`, then `.agents/skills/<name>/SKILL.md` (later directory wins). A lone `.agents/SKILL.md` is not that layout: https://github.com/CodebuffAI/freebuff/blob/78ee2cf53f08048c4be89fbb7a63098ff2f50b66/sdk/src/skills/load-skills.ts
- `sdk/CHANGELOG.md` records the same knowledge-file order and the removal of `knowledge.md`: https://github.com/CodebuffAI/freebuff/blob/78ee2cf53f08048c4be89fbb7a63098ff2f50b66/sdk/CHANGELOG.md

**Kilo Code**

- `AGENTS.md`: https://kilo.ai/docs/customize/agents-md
- `AGENTS.md`, `CLAUDE.md`, and `CONTEXT.md`: https://kilo.ai/docs/customize/custom-instructions
- Skills, `.agents/skills/` by default, `.kilo/skills/`, `.claude/skills/` when compatibility is on: https://kilo.ai/docs/customize/skills

## Source project

- Original repo: https://github.com/usestrix/strix
- License: Apache 2.0 (`LICENSE`, `NOTICE`)
- Docs: https://docs.strix.ai
