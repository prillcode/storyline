# Show Status Workflow

**Purpose:** Analyze current project state and suggest next actions.

**Context:** User ran `/sl-setup status`

## Steps

### 1. Detect Project Directory

Use Bash tool to check for .storyline/ (v2.1+) first, then fall back to .workflow/ (v2.0):
```bash
if [ -d ".storyline" ]; then
  echo "ROOT_DIR=.storyline"
elif [ -d ".workflow" ]; then
  echo "ROOT_DIR=.workflow"
  echo "LEGACY_MODE=true"
else
  echo "NOT_FOUND"
fi
```

**If NOT_FOUND:**
```
No Storyline project found in this directory.

To get started:
  /sl-setup init    # Initialize project
  /sl-setup guide   # Learn the workflow
```
Stop here.

**If .workflow/ found (legacy):**
Display a gentle migration reminder:
```
📦 Using .workflow/ (legacy v2.0 structure)

Tip: Storyline v2.1 uses .storyline/ for better branding.
Run `/sl-setup` to migrate (takes seconds, preserves all work).
```

**If EXISTS:**
Continue to analysis using detected ROOT_DIR...

### 2. Detect Subdirectory Case

**Important:**
- Both `.storyline/` (v2.1+) and `.workflow/` (v2.0 legacy) support lowercase or uppercase subdirectories
- Lowercase is preferred, but uppercase is also valid

Use Bash tool to detect subdirectories using ROOT_DIR from step 1:
```bash
# Use ROOT_DIR detected in step 1
ROOT_DIR="${ROOT_DIR:-.storyline}"

# Detect epics directory (check uppercase only for legacy .workflow/)
if [ -d "$ROOT_DIR/epics" ]; then
  echo "EPICS_DIR=$ROOT_DIR/epics"
elif [ -d "$ROOT_DIR/EPICS" ]; then
  echo "EPICS_DIR=$ROOT_DIR/EPICS"
else
  echo "EPICS_DIR="
fi

# Detect stories directory
if [ -d "$ROOT_DIR/stories" ]; then
  echo "STORIES_DIR=$ROOT_DIR/stories"
elif [ -d "$ROOT_DIR/STORIES" ]; then
  echo "STORIES_DIR=$ROOT_DIR/STORIES"
else
  echo "STORIES_DIR="
fi

# Detect specs directory
if [ -d "$ROOT_DIR/specs" ]; then
  echo "SPECS_DIR=$ROOT_DIR/specs"
elif [ -d "$ROOT_DIR/SPECS" ]; then
  echo "SPECS_DIR=$ROOT_DIR/SPECS"
else
  echo "SPECS_DIR="
fi
```

Store the detected paths and use them in all subsequent scans.

### 3. Scan PRDs

Use Glob tool to find all PRD files using detected ROOT_DIR:
```
pattern: "{ROOT_DIR}/PRD-*.md"
```

For each PRD found:
- Extract identifier from filename (e.g., `PRD-mco-1234.md` → `mco-1234`)
- Store in list

### 4. Scan Epics

Use Glob tool with detected epics directory path:
```
pattern: "{EPICS_DIR}/epic-*.md"
```

For each epic:
- Extract identifier and epic number from filename
- Group by identifier (match to PRD)
- Count epics per identifier

### 5. Scan Stories

Use Bash tool to list story directories with detected path:
```bash
find {STORIES_DIR} -type d -mindepth 1 -maxdepth 1 2>/dev/null | sort
```

For each epic directory:
- Extract epic ID from directory name
- Count story files in that directory:
  ```bash
  ls {STORIES_DIR}/epic-{id}/*.md 2>/dev/null | wc -l
  ```

**Also scan for standalone stories:**
```bash
if [ -d "{STORIES_DIR}/.standalone" ]; then
  ls {STORIES_DIR}/.standalone/story-*.md 2>/dev/null | wc -l
fi
```

Store standalone story count separately.

### 6. Scan Specs

Use Bash tool to list spec directories with detected path:
```bash
find {SPECS_DIR} -type d -mindepth 1 -maxdepth 1 2>/dev/null | sort
```

For each epic directory:
- Extract epic ID
- Count spec files:
  ```bash
  ls {SPECS_DIR}/epic-{id}/*.md 2>/dev/null | wc -l
  ```

**Also scan for standalone specs:**
```bash
if [ -d "{SPECS_DIR}/.standalone" ]; then
  ls {SPECS_DIR}/.standalone/spec-*.md 2>/dev/null | wc -l
fi
```

Store standalone spec count separately.

### 7. Build Status Table

Correlate all data collected:
- Group epics by identifier
- Match stories and specs to epics
- Determine status for each PRD/initiative

**Status determination:**
- "Not started" - PRD exists but no epics
- "Epics only" - Has epics but no stories
- "Stories created" - Has stories but no specs
- "Ready to develop" - Has specs but no implementation
- "In progress" - Mix of complete and incomplete work
- "Complete" - All epics have stories and specs

### 8. Display Status Report

**If no PRDs found:**
```
Storyline Project Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

No PRDs found yet.

Next step: Create your first epic
  /sl-epic-creator              # Guided mode (no PRD needed)
  /sl-epic-creator [prd-path]   # From existing PRD
```

**If PRDs found:**
```
Storyline Project Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Epic-Based Work:
| Initiative      | Epics | Stories | Specs | Status          |
|-----------------|-------|---------|-------|-----------------|
| PRD-mco-1234.md | 2     | 5       | 4     | In progress     |
| PRD-feat-789.md | 1     | 3       | 3     | Ready to develop|
| PRD-001.md      | 1     | 0       | 0     | Epics only      |

Standalone Work (no epic required):
• Stories: {standalone_story_count}
• Specs: {standalone_spec_count}

Summary:
• 3 PRDs/initiatives
• 4 epics total
• 8 epic-based stories + {standalone_story_count} standalone stories
• 7 epic-based specs + {standalone_spec_count} standalone specs
```

**If only standalone work exists (no PRDs/epics):**
```
Storyline Project Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Standalone Work (no epic required):
• Stories: {standalone_story_count}
• Specs: {standalone_spec_count}

No epic-based work found.

To create standalone stories: /sl-story-creator
To create epic-based work: /sl-epic-creator
```

### 9. Suggest Next Actions

Analyze the data and provide specific, actionable suggestions.

**Important:** Use detected directory paths in suggestions (not hardcoded paths).

**If epics exist but no stories:**
```
📋 Next suggested action:

Create stories from epic:
  /sl-story-creator {EPICS_DIR}/epic-001-*.md
```

**If stories exist but no specs:**
```
📋 Next suggested action:

Create spec from story:
  /sl-spec-story {STORIES_DIR}/epic-001/story-01.md
```

**If specs exist (not implemented):**
```
📋 Next suggested action:

Implement spec:
  /sl-develop {SPECS_DIR}/epic-001/spec-01.md
```

**If multiple items at different stages:**
```
📋 Suggested next actions:

Continue epic-mco-1234-01:
  /sl-spec-story {STORIES_DIR}/epic-mco-1234-01/story-03.md

Start stories for epic-001:
  /sl-story-creator {EPICS_DIR}/epic-001-*.md

Implement ready specs:
  /sl-develop {SPECS_DIR}/epic-mco-1234-01/spec-01.md
```

**If standalone stories exist but no specs:**
```
📋 Next suggested action for standalone work:

Create spec from standalone story:
  /sl-spec-story {STORIES_DIR}/.standalone/story-{slug}.md
```

**If standalone specs exist (not implemented):**
```
📋 Next suggested action for standalone work:

Implement standalone spec:
  /sl-develop {SPECS_DIR}/.standalone/spec-{slug}.md
```

### 10. Show Incomplete Workflows

If any epic has gaps in the pipeline:
```
⚠️  Incomplete workflows detected:

epic-mco-1234-02: Has epics but no stories yet
epic-001: Has stories but no specs yet
```

### 11. Traceability Quick Reference

If project has files, show a sample chain using detected paths:

**Epic-based chain:**
```
  PRD-mco-1234.md
  └─ {EPICS_DIR}/epic-mco-1234-01-auth.md
     └─ {STORIES_DIR}/epic-mco-1234-01/story-01.md
        └─ {SPECS_DIR}/epic-mco-1234-01/spec-01.md
```

**Standalone chain:**
```
  Standalone work (adhoc bug fixes, small features)
  └─ {STORIES_DIR}/.standalone/story-fix-login.md
     └─ {SPECS_DIR}/.standalone/spec-fix-login.md
```

## Implementation Notes

**Directory case sensitivity:**
- Root directory (`.storyline/` or `.workflow/`) MUST be lowercase (required)
- Subdirectories (epics/stories/specs) can be lowercase OR uppercase
- Always detect which case is used and adapt
- Never assume or hardcode directory names in output
- Prefer `.storyline/` over `.workflow/` when both exist (shouldn't happen, but failsafe)

**Use tables for clarity:** Align columns, show numbers clearly.

**Be specific:** Don't just say "create stories" - show exact command with file path.

**Prioritize suggestions:** Most urgent/logical next step first.

**Handle empty directories:** Don't fail if .workflow/ exists but is empty.

**Show paths correctly:** Use actual detected paths found, not placeholders.

**Count accurately:** Use tools to count files, don't guess.

## Edge Cases

**Empty project directory:**
```
Storyline project initialized but empty.

Next step: Create your first epic
  /sl-epic-creator
```

**Mixed old and new structure:** Some files with identifiers, some without
```
⚠️  Detected mixed file structure (v1 and v2 files).

This is OK! New features are backward compatible.
```

**Orphaned files:** Stories without parent epic
```
⚠️  Found orphaned files:
  {ROOT_DIR}/stories/story-old.md (no parent epic)

Consider organizing these files or removing them.
```

## Error Handling

**Cannot read project directory:**
```
❌ Cannot read project directory.

Check permissions:
  chmod +r .storyline/    # or .workflow/ for legacy projects
```

**Malformed filenames:**
Skip files that don't match expected patterns and continue analysis.

**Empty report:**
If absolutely nothing found:
```
Project directory exists but appears empty.

To create your first epic:
  /sl-epic-creator
```
