# Storyline Workflow

This directory contains all Storyline artifacts for this project.

## Directory Structure

```
.storyline/
├── README.md           # This file
├── PRD-*.md            # Product requirements documents
├── epics/              # Epic-level themes from PRDs
├── stories/            # User stories (grouped by epic)
├── specs/              # Technical specifications (grouped by epic)
└── .planning/          # Auto-generated execution plans
```

## The Workflow

```
PRD → Epics → Stories → Specs → Implementation
```

Each stage refines the work until it's ready to execute.

## Commands

### Starting a new body of work

```bash
/sl-epic-creator              # Guided mode (no PRD needed)
/sl-epic-creator [prd-path]   # From existing PRD document
```

### Creating stories from epics

```bash
/sl-story-creator .storyline/epics/epic-[id]-01-*.md
```

### Creating specs from stories

```bash
/sl-spec-story .storyline/stories/epic-[id]-01/story-01.md
```

### Implementing specs

```bash
/sl-develop .storyline/specs/epic-[id]-01/spec-01.md
```

### Project management

```bash
/sl-setup status    # Check current project state
/sl-setup guide     # See full tutorial
/sl-setup check     # Verify installation
```

## Identifiers (Optional)

Use identifiers to track work back to your project management system (JIRA, Linear, etc.).

**Format:** Alphanumeric + hyphens/underscores
**Examples:** `MCO-1234`, `feature-789`, `PROJ_ABC`

When you provide an identifier:
- PRD: `PRD-mco-1234.md`
- Epics: `epic-mco-1234-01-auth.md`
- Stories: `.storyline/stories/epic-mco-1234-01/story-01.md`
- Specs: `.storyline/specs/epic-mco-1234-01/spec-01.md`

If you skip the identifier:
- PRD: `PRD-001.md`
- Epics: `epic-001-auth.md`
- Stories: `.storyline/stories/epic-001/story-01.md`
- Specs: `.storyline/specs/epic-001/spec-01.md`

## Multi-Initiative Projects

You can have multiple PRDs with different identifiers in one project:

```
.storyline/
├── PRD-mco-1234.md       # First initiative
├── PRD-feature-789.md    # Second initiative
├── epics/
│   ├── epic-mco-1234-01-*.md
│   └── epic-feature-789-01-*.md
├── stories/
│   ├── epic-mco-1234-01/
│   └── epic-feature-789-01/
└── specs/
    ├── epic-mco-1234-01/
    └── epic-feature-789-01/
```

## Traceability

Every file links back to its parent:

```
PRD-mco-1234.md
└─ epic-mco-1234-01-auth.md
   └─ stories/epic-mco-1234-01/story-01.md
      └─ specs/epic-mco-1234-01/spec-01.md
         └─ Code commits
```

## Tips

**Check status often:**
```bash
/sl-setup status
```
Shows what's done and suggests next actions.

**Start small:** Don't over-plan. Create one epic, implement one story, iterate.

**Use identifiers for tracking:** Makes it easy to connect Storyline work to tickets.

**Commit this directory:** These files ARE your project documentation.

**Don't commit .planning/:** Plans are temporary. Specs are the source of truth.

## Learn More

```bash
/sl-setup guide     # Full tutorial
```

Or visit: https://github.com/anthropics/storyline

---

**Storyline v2.0** - Story-driven development workflow
