# skill-Strix maintainers

This checkout is the methodology package. Working here is not authorization to perform security testing.

Do not run pentests, scans, or exploit tooling from this repository. A filled scope in some other engagement does not make this checkout a target.

Canonical methodology is `.agents/SKILL.md`. Do not edit that file to add harness packaging, and do not paste it into `adapters/`.

Discoverable wrapper: `.agents/skills/strix-pentest/SKILL.md`.

Copy sources: `adapters/<harness>/`. Install notes are in `README.md`.

Checks:

```sh
sh tests/test-references.sh
sh tests/test-new-engagement.sh
sh tests/test-harness-adapters.sh
```
