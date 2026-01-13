# Show Status Workflow

**Purpose:** Analyze current project state and suggest next actions.

**Context:** User ran `/sl-setup status`

## Steps

### 1. Check if .workflow/ Exists

Use Bash tool:
```bash
[ -d ".workflow" ] && echo "EXISTS" || echo "NOT_FOUND"
```

**If NOT_FOUND:**
```
No Storyline project found in this directory.

To get started:
  /sl-setup init    # Initialize project
  /sl-setup guide   # Learn the workflow
```
Stop here.

**If EXISTS:**
Continue to analysis...

### 2. Scan PRDs

Use Glob tool to find all PRD files:
```
pattern: ".workflow/PRD-*.md"
```

For each PRD found:
- Extract identifier from filename (e.g., `PRD-mco-1234.md` → `mco-1234`)
- Store in list

### 3. Scan Epics

Use Glob tool:
```
pattern: ".workflow/epics/epic-*.md"
```

For each epic:
- Extract identifier and epic number from filename
- Group by identifier (match to PRD)
- Count epics per identifier

### 4. Scan Stories

Use Bash tool to list story directories:
```bash
find .workflow/stories -type d -mindepth 1 -maxdepth 1 2>/dev/null | sort
```

For each epic directory:
- Extract epic ID from directory name
- Count story files in that directory:
  ```bash
  ls .workflow/stories/epic-{id}/*.md 2>/dev/null | wc -l
  ```

### 5. Scan Specs

Use Bash tool to list spec directories:
```bash
find .workflow/specs -type d -mindepth 1 -maxdepth 1 2>/dev/null | sort
```

For each epic directory:
- Extract epic ID
- Count spec files:
  ```bash
  ls .workflow/specs/epic-{id}/*.md 2>/dev/null | wc -l
  ```

### 6. Build Status Table

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

### 7. Display Status Report

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

| Initiative      | Epics | Stories | Specs | Status          |
|-----------------|-------|---------|-------|-----------------|
| PRD-mco-1234.md | 2     | 5       | 4     | In progress     |
| PRD-feat-789.md | 1     | 3       | 3     | Ready to develop|
| PRD-001.md      | 1     | 0       | 0     | Epics only      |

Summary:
• 3 PRDs/initiatives
• 4 epics total
• 8 stories total
• 7 specs total
```

### 8. Suggest Next Actions

Analyze the data and provide specific, actionable suggestions:

**If epics exist but no stories:**
```
📋 Next suggested action:

Create stories from epic:
  /sl-story-creator .workflow/epics/epic-001-*.md
```

**If stories exist but no specs:**
```
📋 Next suggested action:

Create spec from story:
  /sl-spec-story .workflow/stories/epic-001/story-01.md
```

**If specs exist (not implemented):**
```
📋 Next suggested action:

Implement spec:
  /sl-develop .workflow/specs/epic-001/spec-01.md
```

**If multiple items at different stages:**
```
📋 Suggested next actions:

Continue epic-mco-1234-01:
  /sl-spec-story .workflow/stories/epic-mco-1234-01/story-03.md

Start stories for epic-001:
  /sl-story-creator .workflow/epics/epic-001-*.md

Implement ready specs:
  /sl-develop .workflow/specs/epic-mco-1234-01/spec-01.md
```

### 9. Show Incomplete Workflows

If any epic has gaps in the pipeline:
```
⚠️  Incomplete workflows detected:

epic-mco-1234-02: Has epics but no stories yet
epic-001: Has stories but no specs yet
```

### 10. Traceability Quick Reference

If project has files, show a sample chain:
```
Example traceability chain:
  PRD-mco-1234.md
  └─ epic-mco-1234-01-auth.md
     └─ stories/epic-mco-1234-01/story-01.md
        └─ specs/epic-mco-1234-01/spec-01.md
```

## Implementation Notes

**Use tables for clarity:** Align columns, show numbers clearly.

**Be specific:** Don't just say "create stories" - show exact command with file path.

**Prioritize suggestions:** Most urgent/logical next step first.

**Handle empty directories:** Don't fail if .workflow/ exists but is empty.

**Show paths correctly:** Use actual filenames found, not placeholders.

**Count accurately:** Use tools to count files, don't guess.

## Edge Cases

**Empty .workflow/ directory:**
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
  .workflow/stories/story-old.md (no parent epic)

Consider organizing these files or removing them.
```

## Error Handling

**Cannot read .workflow/:**
```
❌ Cannot read .workflow/ directory.

Check permissions:
  chmod +r .workflow/
```

**Malformed filenames:**
Skip files that don't match expected patterns and continue analysis.

**Empty report:**
If absolutely nothing found:
```
.workflow/ exists but appears empty.

To create your first epic:
  /sl-epic-creator
```
