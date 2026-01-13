# Storyline v2.0.0 Release Notes

**Release Date:** January 12, 2026

## Overview

Storyline v2.0.0 is a major release that transforms Storyline from a simple linear workflow tool into a production-ready system for managing multiple bodies of work within a single project. This release adds comprehensive setup/onboarding, flexible identifier tracking, and improved project organization.

## What's New

### 🎯 Setup & Onboarding (`/sl-setup`)

A new comprehensive setup command to help users get started and track their progress:

- **`/sl-setup`** - Interactive setup and onboarding
- **`/sl-setup init`** - Initialize `.workflow/` directory structure
- **`/sl-setup status`** - Show project state and suggest next steps
- **`/sl-setup guide`** - Display comprehensive tutorial
- **`/sl-setup check`** - Verify Storyline installation

### 🏷️ Identifier System

Optional tracking codes that propagate through the entire workflow chain:

- Link work items to external systems (JIRA tickets, feature codes, etc.)
- Identifiers propagate: PRD → Epics → Stories → Specs → Implementation
- Format: Alphanumeric + hyphens/underscores (e.g., `JIRA-123`, `feature-789`)
- Completely optional - projects without identifiers still work perfectly

**Example:**
```
PRD-jira-123.md
  └─ epic-jira-123-01-auth.md
      └─ stories/epic-jira-123-01/story-01.md
          └─ specs/epic-jira-123-01/spec-01.md
```

### 📁 Epic Subdirectories

Stories and specs are now organized by epic for better scalability:

**Old structure (v1.x):**
```
.workflow/
├── stories/
│   ├── story-001-signup.md
│   └── story-002-login.md
└── specs/
    ├── spec-001-signup.md
    └── spec-002-login.md
```

**New structure (v2.0):**
```
.workflow/
├── stories/
│   ├── epic-jira-123-01/
│   │   ├── story-01.md
│   │   └── story-02.md
│   └── epic-jira-123-02/
│       └── story-01.md
└── specs/
    ├── epic-jira-123-01/
    │   ├── spec-01.md
    │   └── spec-stories-02-03-combined.md
    └── epic-jira-123-02/
        └── spec-01.md
```

### 🎭 Flexible Spec Strategies

Three strategies for creating specs from stories:

1. **Simple** - One story → one spec (`spec-01.md`)
2. **Complex** - One story → multiple specs (`spec-story02-01.md`, `spec-story02-02.md`)
3. **Combined** - Multiple stories → one spec (`spec-stories-02-03-combined.md`)

The system prompts you to choose the best strategy when creating specs.

### 📊 Multi-Initiative Support

Multiple PRDs with different identifiers can coexist in one project:

```
.workflow/
├── PRD-jira-123.md      # First initiative
├── PRD-feature-789.md   # Second initiative
├── PRD-proj-abc.md      # Third initiative
└── epics/
    ├── epic-jira-123-01-auth.md
    ├── epic-jira-123-02-tasks.md
    ├── epic-feature-789-01-export.md
    └── epic-proj-abc-01-settings.md
```

### 🧭 Guided PRD Creation

Run `/sl-epic-creator` without arguments for interactive PRD creation:

- Answer guided questions about your project
- Optional identifier entry
- Automatic PRD generation
- Seamless transition to epic creation

### 🔗 Enhanced Traceability

All templates now include complete traceability chains:

**Spec frontmatter example:**
```yaml
---
spec_id: 01
story_ids: [01]
epic_id: jira-123-01
identifier: jira-123
parent_story: ../stories/epic-jira-123-01/story-01.md
parent_epic: ../epics/epic-jira-123-01-auth.md
complexity: simple
---
```

## Command Changes

### Renamed

- `/sl-dev-story` → **`/sl-develop`** (for consistency with other commands)

### New Commands

- **`/sl-setup [command]`** - Project initialization and management

### Enhanced Commands

All existing commands now support:
- Identifier extraction and propagation
- Epic subdirectory organization
- Enhanced frontmatter with traceability

## Breaking Changes

**None!** This release is fully backward compatible with v1.x projects:

- Old projects without identifiers continue to work
- Flat directory structures are still supported
- All new features are opt-in
- No existing workflows are broken

## Migration Guide

### For Existing Projects (v1.x → v2.0)

No migration needed! Your existing projects will continue to work exactly as before.

To start using v2.0 features:

1. **Add identifiers to new work:**
   - Next time you run `/sl-epic-creator`, provide an identifier when prompted
   - New epics will use the v2.0 structure

2. **Try the setup command:**
   - Run `/sl-setup status` to see your project state
   - Use `/sl-setup guide` to learn about new features

3. **Gradual adoption:**
   - Mix old and new structures in the same project
   - No need to retrofit existing work items

### For New Projects

Use the new setup workflow:

```bash
/sl-setup init                  # Initialize project
/sl-epic-creator                # Guided PRD creation with identifier
# Continue with rest of workflow...
```

## Installation

### Update to v2.0.0

**Option 1: One-line remote install**
```bash
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash
```

**Option 2: Manual update**
```bash
cd ~/.local/share/storyline
git pull origin main
git submodule update --init --recursive
./install.sh
```

### Verify Installation

Start a new Claude Code session and run:
```bash
/sl-setup check
```

Should show: `Version: 2.0.0`

## Updated Documentation

- [README.md](README.md) - Updated with v2.0 features and examples
- [examples/sample-workflow/](examples/sample-workflow/) - Updated for v2.0 patterns
- All skill documentation enhanced with identifier system

## Technical Details

### Files Changed

- **34 files changed**
- **3,691 insertions, 196 deletions**

### New Skills

- `storyline-setup/` - Complete setup and onboarding skill

### New Workflows

- `guided-prd-creation.md` - Interactive PRD creation
- `create-spec-from-story.md` - Enhanced spec creation with strategies
- 5 new setup workflows (init, status, guide, check, interactive)

### New References

- `identifier-system.md` - Identifier format rules and validation
- Setup reference files (directory-structure, workflow-patterns, troubleshooting)

### Enhanced Templates

All templates updated with:
- Identifier fields in frontmatter
- Enhanced traceability sections
- Relative path updates for subdirectories

## Known Issues

None at this time.

## Credits

Built by [prillcode](https://github.com/prillcode)

Storyline is built on the excellent [taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources) framework by glittercowboy. See [CREDITS.md](CREDITS.md) for detailed attribution.

## Support

- **Issues:** [GitHub Issues](https://github.com/prillcode/storyline/issues)
- **Discussions:** [GitHub Discussions](https://github.com/prillcode/storyline/discussions)
- **Documentation:** [docs/](docs/)

## What's Next

Looking ahead to v2.1 and beyond:

- Integration with project management APIs (JIRA, Linear, etc.)
- Automatic identifier extraction from commits
- Status dashboards and progress tracking
- Team collaboration features
- Template customization system

---

**Happy building with Storyline v2.0!** 📖✨

For full technical specification, see [.workflow/specs/spec-storyline-v2-enhancements.md](.workflow/specs/spec-storyline-v2-enhancements.md)
