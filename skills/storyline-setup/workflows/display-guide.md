# Display Guide Workflow

**Purpose:** Show comprehensive onboarding tutorial and documentation.

**Context:** User ran `/sl-setup guide`

## Steps

### 1. Load Reference Materials

Read the following reference files for context:
- references/directory-structure.md
- references/workflow-patterns.md

### 2. Display Comprehensive Guide

Display the following tutorial content:

```markdown
# Storyline Guide

## Overview

Storyline transforms product ideas into executable code through a proven workflow.

**The Pipeline:**
```
PRD → Epics → Stories → Specs → Implementation
```

Each stage refines and breaks down the work until it's ready to execute.

## The Workflow

### Starting Fresh (No PRD)

1. **Initialize project**
   ```
   /sl-setup init
   ```
   Creates .workflow/ directory structure.

2. **Create epics** (guided mode)
   ```
   /sl-epic-creator
   ```

   No PRD file? No problem! You'll be guided through:
   - Goal/theme of the work
   - Primary users/stakeholders
   - Core features needed
   - Constraints and requirements
   - Success criteria

   Optional: Provide an identifier (e.g., JIRA ticket "MCO-1234") to track this work.

   Output: PRD-{identifier}.md + epic files in .workflow/epics/

3. **Generate stories from epic**
   ```
   /sl-story-creator .workflow/epics/epic-{id}-01-*.md
   ```

   Breaks down epic into user stories.
   Output: Stories in .workflow/stories/epic-{id}-01/

4. **Create technical spec**
   ```
   /sl-spec-story .workflow/stories/epic-{id}-01/story-01.md
   ```

   Converts story into implementation-ready spec.
   Output: Spec in .workflow/specs/epic-{id}-01/

5. **Implement the spec**
   ```
   /sl-develop .workflow/specs/epic-{id}-01/spec-01.md
   ```

   Converts spec to plan and executes it.
   Output: Code changes + summary

### Starting with Existing PRD

1. **Initialize project**
   ```
   /sl-setup init
   ```

2. **Create epics from PRD**
   ```
   /sl-epic-creator docs/PRD.md
   ```

   Provide optional identifier when prompted.
   Output: Epic files in .workflow/epics/

3. **Continue with stories, specs, and implementation** (same as above)

### Adding a New Feature

If you already have a Storyline project and want to add a new feature:

1. **Create new epics** (new PRD, new identifier)
   ```
   /sl-epic-creator
   ```

   Use a different identifier (e.g., "FEATURE-789") to keep it separate.

2. **Continue the pipeline** for the new feature

Your project can have multiple PRDs/initiatives coexisting in .workflow/!

### Understanding Your Progress

At any time, check where you are:
```
/sl-setup status
```

Shows:
- All PRDs in project
- Epics per PRD
- Stories and specs per epic
- Suggested next actions

## Identifiers

**What are they?**
Optional tracking codes (e.g., JIRA tickets, feature codes).

**Format:**
- Alphanumeric + hyphens/underscores
- Examples: `MCO-1234`, `feature-789`, `PROJ_ABC`, `v2-migration`

**Why use them?**
- Track work back to project management tools
- Organize multiple initiatives in one project
- Keep PRD/epic/story/spec connected

**What if I skip them?**
No problem! Storyline uses numbers instead: `001`, `002`, etc.

## Directory Structure

```
project-root/
├── .workflow/
│   ├── PRD-{identifier}.md      # First initiative
│   ├── PRD-{another}.md         # Later features
│   ├── epics/
│   │   ├── epic-{id}-01-auth.md
│   │   └── epic-{id}-02-tasks.md
│   ├── stories/
│   │   ├── epic-{id}-01/        # Stories grouped by epic
│   │   │   ├── story-01.md
│   │   │   └── story-02.md
│   │   └── epic-{id}-02/
│   │       └── story-01.md
│   ├── specs/
│   │   ├── epic-{id}-01/
│   │   │   ├── spec-01.md
│   │   │   └── spec-02.md
│   │   └── epic-{id}-02/
│   │       └── spec-01.md
│   └── .planning/               # Auto-generated plans
└── src/                         # Your actual code
```

### Why Epic Subdirectories?

Stories and specs are organized by epic to:
- Keep related work together
- Support multiple PRDs in one project
- Make traceability clear
- Scale to large projects

## Spec Strategies

When creating specs from stories, you have options:

**Simple (1 story → 1 spec):**
Most common. One story becomes one spec.
```
spec-01.md
spec-02.md
```

**Complex (1 story → multiple specs):**
For large stories that need splitting.
```
spec-story02-01.md
spec-story02-02.md
```

**Combined (multiple stories → 1 spec):**
For small related stories.
```
spec-stories-02-03-combined.md
```

## Tips

**Start small:** Don't try to model your entire product in one PRD. Start with one feature.

**Iterate:** You can always create more epics/PRDs later.

**Use identifiers for tracking:** If you use JIRA or similar tools, identifiers are invaluable.

**Check status often:** `/sl-setup status` shows you exactly where you are.

**One story can split:** If a story is too complex, create multiple specs.

**Multiple stories can combine:** If stories are too simple, combine into one spec.

## Common Patterns

See references/workflow-patterns.md for detailed examples.

## Troubleshooting

Having issues? See references/troubleshooting.md or run:
```
/sl-setup check
```

## Next Steps

Ready to start?
```
/sl-setup init      # Initialize your project
/sl-epic-creator    # Create your first epic
```

Or check current state:
```
/sl-setup status    # See what you've done
```
```

## Implementation Notes

**Include directory tree:** Visual structure helps understanding.

**Show examples:** Use concrete examples with identifiers.

**Progressive disclosure:** Start with simple flow, then show variations.

**Actionable commands:** Show exact commands to run.

**Link to references:** Point to reference files for more detail.

**Keep it scannable:** Use headers, code blocks, bullet points.

## After Displaying Guide

Ask user:
```
What would you like to do next?
```

Use AskUserQuestion:
1. "Initialize my project" → workflows/init-project.md
2. "Check project status" → workflows/show-status.md
3. "Verify installation" → workflows/verify-installation.md
4. "Nothing, I'm good" → End
