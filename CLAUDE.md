# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Storyline is a CLI toolkit for Claude Code implementing story-driven development. It provides skills and commands that transform PRDs into working code through the pipeline: **Epic → Story → Spec → Implementation**.

This is NOT a typical code project - it's a collection of Claude Code skills (in `skills/`) and slash commands (in `commands/`) that get installed to `~/.claude/`.

## Development Commands

```bash
# Install/reinstall after making changes
./install.sh

# Uninstall
./uninstall.sh

# Windows installation (from cloned repo)
.\windows-install.cmd
```

After modifying skills or commands, run `./install.sh` and start a new Claude Code session to test changes.

## Architecture

### Skill Structure (Router Pattern)

Each skill follows the router pattern from taches-cc-resources:

```
skills/skill-name/
├── SKILL.md              # Router + essential principles
├── workflows/            # Step-by-step procedures
├── references/           # Domain knowledge
└── templates/            # Output structures
```

- **SKILL.md**: Contains `<routing>` section that dispatches to workflows based on arguments
- **Workflows**: Loaded on-demand (progressive disclosure) to minimize context usage
- **References**: Domain knowledge loaded only when needed

### Command Files

Commands in `commands/` are simple markdown files with YAML frontmatter:

```yaml
---
description: What the command does
allowed-tools: Skill(skill-name)
argument-hint: <hint for arguments>
---
Invoke the skill-name skill for: $ARGUMENTS
```

### Key Skills

| Skill | Purpose |
|-------|---------|
| storyline-setup | Project init, status, verification |
| storyline-epic-creator | PRD → Epics (supports guided mode) |
| storyline-story-creator | Epic → Stories (or standalone stories) |
| storyline-spec-story | Story → Technical Spec |
| storyline-develop | Spec → Implementation via create-plans |
| storyline-commit | Git commits with conventional format |

### Dependencies

Uses `dependencies/cc-resources/` git submodule (fork of taches-cc-resources) which provides:
- `create-plans` skill for hierarchical planning and execution
- `create-agent-skills` for skill authoring patterns
- Various utility commands and agents

Clone with `--recurse-submodules` or run `git submodule update --init --recursive`.

## Project Directory Structure (v2.1+)

When Storyline is used in a target project, it creates:

```
.storyline/
├── PRD-{identifier}.md       # Product requirements
├── epics/                    # Epic files
├── stories/                  # Stories organized by epic
│   ├── .standalone/          # Stories without epic
│   └── epic-{id}-01/         # Stories for specific epic
├── specs/                    # Technical specs mirroring stories structure
└── .planning/                # Generated plans and summaries
```

Supports both `.storyline/` (v2.1+) and `.workflow/` (v2.0 legacy).

## Contribution Patterns

- Follow router pattern for complex skills
- Use pure XML structure in SKILL.md (no markdown headings in skill body)
- Progressive disclosure: load only what's needed
- Test by reinstalling and starting fresh Claude Code session
