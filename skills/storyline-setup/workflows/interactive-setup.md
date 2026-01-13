# Interactive Setup Workflow

**Purpose:** Comprehensive onboarding and project initialization for new Storyline users.

**Context:** User ran `/sl-setup` without arguments.

## CRITICAL: Correct Directory Structure

**The official Storyline structure (v2.1+):**
- Root directory: `.storyline/` (lowercase, required)
- Subdirectories: `epics/`, `stories/`, `specs/` (lowercase preferred, uppercase also supported)

**Legacy support:**
- `.workflow/` directory from v2.0 is still supported for backward compatibility
- Projects can migrate from `.workflow/` to `.storyline/` during setup

**If .storyline/ exists with correct subdirectories, the project IS set up correctly.**

## Steps

### 1. Check Current Project State

Use Bash tool to check for both new and legacy directories:

```bash
# Check for .storyline/ (v2.1+)
if [ -d ".storyline" ]; then
  echo "STORYLINE_EXISTS"
  ls -d .storyline/epics .storyline/stories .storyline/specs .storyline/EPICS .storyline/STORIES .storyline/SPECS 2>/dev/null | tr '\n' ' '
# Check for .workflow/ (v2.0 legacy)
elif [ -d ".workflow" ]; then
  echo "WORKFLOW_EXISTS"
  ls -d .workflow/epics .workflow/stories .workflow/specs .workflow/EPICS .workflow/STORIES .workflow/SPECS 2>/dev/null | tr '\n' ' '
else
  echo "NOT_FOUND"
fi
```

### 2. Branch Based on State

#### If .storyline/ EXISTS with subdirectories:

**This is a VALID Storyline v2.1+ project!** Display:
```
✅ Storyline is already set up in this project!

Current state:
[Show brief status - count of PRDs, epics, stories, specs]

What would you like to do?
```

Then use AskUserQuestion tool:
- Question: "How would you like to proceed?"
- Options:
  1. "View project status" → workflows/show-status.md
  2. "View getting started guide" → workflows/display-guide.md
  3. "Verify installation" → workflows/verify-installation.md
  4. "Exit" → End

#### If .workflow/ EXISTS with subdirectories (Legacy v2.0):

**Migration opportunity!** Display:
```
📦 Found Storyline v2.0 project using .workflow/ directory

Storyline v2.1 now uses .storyline/ for better branding.
Would you like to migrate your existing work?
```

Then use AskUserQuestion tool:
- Question: "Migrate from .workflow/ to .storyline/?"
- Options:
  1. "Yes, migrate now (recommended)" → Perform migration (see Migration Logic below)
  2. "No, keep using .workflow/ (legacy mode)" → Display: "Continuing with .workflow/ (legacy mode). Your project will still work but we recommend migrating when ready."

**Migration Logic (when user selects "Yes"):**
```bash
# Move the entire directory
mv .workflow .storyline
```

Then verify and display:
```bash
ls -la .storyline/
```

Display:
```
✅ Migration complete!

Migrated to .storyline/:
  .storyline/
  ├── PRD files
  ├── epics/
  ├── stories/
  ├── specs/
  └── .planning/

All your existing work has been preserved.
```

Then continue to "What would you like to do?" options above.

#### If NEITHER directory found:

Continue to initialization...

### 3. Welcome and Philosophy (New Project)

Display:
```
Welcome to Storyline!

Storyline helps you break down product ideas into executable code using a proven workflow:

PRD → Epics → Stories → Specs → Implementation

Key concepts:
• A project has many bodies of work over its lifetime
• Each PRD represents one epic-sized initiative
• Identifiers (optional) help track work back to your planning system (JIRA, etc.)
• Everything is organized in .storyline/ directory
```

### 4. Initialize Project

Call the init workflow directly (don't use Tool, just execute inline):

Create directories:
```bash
mkdir -p .storyline/epics .storyline/stories .storyline/specs .storyline/.planning
```

Load references/directory-structure.md and templates/workflow-readme.md.

Create `.storyline/README.md` using the template.

Verify creation:
```bash
ls -la .storyline/
```

Display:
```
✅ Project initialized successfully!

Created directory structure:
  .storyline/
  ├── epics/      # Epic-level themes from PRDs
  ├── stories/    # User stories from epics
  ├── specs/      # Technical specifications
  └── .planning/  # Execution plans (auto-generated)
```

### 5. Command Overview

Display:
```
Storyline Commands:

Starting a new body of work:
  /sl-epic-creator        → Create epics from PRD
  /sl-story-creator       → Generate stories from epic
  /sl-spec-story          → Write technical spec from story
  /sl-develop             → Implement spec

Managing your project:
  /sl-setup status        → See project state
  /sl-setup guide         → Full tutorial
  /sl-setup check         → Verify installation
```

### 6. Next Steps Guidance

Use AskUserQuestion tool:
- Question: "What would you like to do next?"
- Options:
  1. "Create my first epic (I have a PRD ready)" → Explain: "Run /sl-epic-creator [path-to-prd]"
  2. "Create my first epic (guided - no PRD yet)" → Explain: "Run /sl-epic-creator without arguments for guided mode"
  3. "Learn more (see full guide)" → workflows/display-guide.md
  4. "Nothing now (exit)" → Display: "You're all set! Run /sl-setup status anytime to see your progress."

### 7. Final Message

Display:
```
Tip: You can run /sl-setup status at any time to see where you are in the workflow.

Happy building! 🚀
```

## Implementation Notes

**Use AskUserQuestion for choices:** Don't just list options, use the tool to get user selection.

**Keep messages concise:** Users want to get started, not read essays.

**Show, don't tell:** Display actual directory structure, not just descriptions.

**Progressive disclosure:** Don't explain identifiers in depth unless user asks.

**Validate directory creation:** Always confirm with ls after creating directories.

## Error Handling

**Cannot create directories:** Permission issues
- Display: "Unable to create .storyline/ directory. Check permissions."
- Suggest: "Try running: chmod +w . or sudo if needed"

**Already initialized but corrupted:** .storyline/ exists but missing subdirectories
- Display: "Found .storyline/ but structure is incomplete. Recreating subdirectories..."
- Run init logic to fill in missing pieces

**Legacy .workflow/ exists but corrupted:**
- Display: "Found .workflow/ but structure is incomplete."
- Offer migration to .storyline/ with structure repair
