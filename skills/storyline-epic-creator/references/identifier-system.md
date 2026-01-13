# Identifier System Reference

## Overview

Identifiers are optional tracking codes that help organize work and connect Storyline artifacts to external systems (JIRA, Linear, etc.).

## Format Rules

**Valid characters:**
- Lowercase letters: a-z
- Uppercase letters: A-Z
- Numbers: 0-9
- Hyphens: -
- Underscores: _

**Regex validation:** `^[a-zA-Z0-9_-]+$`

**Case handling:** Preserve user's case exactly as entered

**Examples:**
```
✅ MCO-1234
✅ mco-1234
✅ feature-789
✅ PROJ_ABC
✅ v2-migration
✅ bug123

❌ MCO 1234    (space not allowed)
❌ MCO#1234    (special char not allowed)
❌ MCO.1234    (period not allowed)
❌ MCO/1234    (slash not allowed)
```

## Identifier Scope

**One identifier per PRD/initiative:**
- Each body of work gets one identifier
- Multiple PRDs can exist in one project
- Each with different identifier

**Identifier propagates through chain:**
```
PRD-{identifier}.md
└─ epic-{identifier}-01-{slug}.md
   └─ stories/epic-{identifier}-01/story-01.md
      └─ specs/epic-{identifier}-01/spec-01.md
         └─ .planning/{identifier}-01-spec-01/PLAN.md
```

## Identifier Storage

### Filenames

**PRD:**
- With identifier: `PRD-mco-1234.md`
- Without: `PRD-001.md`

**Epic:**
- With identifier: `epic-mco-1234-01-auth.md`
- Without: `epic-001-auth.md`
- Format: `epic-{identifier}-{nn}-{slug}.md`

**Story directory:**
- With identifier: `.workflow/stories/epic-mco-1234-01/`
- Without: `.workflow/stories/epic-001/`

**Spec directory:**
- With identifier: `.workflow/specs/epic-mco-1234-01/`
- Without: `.workflow/specs/epic-001/`

### Frontmatter

**PRD:**
```yaml
---
prd_id: mco-1234
created: 2026-01-12
---
```

**Epic:**
```yaml
---
epic_id: mco-1234-01
identifier: mco-1234
epic_number: 01
prd_source: ../PRD-mco-1234.md
---
```

**Story:**
```yaml
---
story_id: 01
epic_id: mco-1234-01
identifier: mco-1234
parent_epic: ../../epics/epic-mco-1234-01-auth.md
---
```

**Spec:**
```yaml
---
spec_id: 01
story_ids: [01]
epic_id: mco-1234-01
identifier: mco-1234
parent_story: ../stories/epic-mco-1234-01/story-01.md
---
```

## Validation Logic

### When Prompting User

```
Optional: Provide an identifier for this work (e.g., JIRA ticket MCO-1234):
[Press Enter to skip]

> MCO-1234
```

**Validation steps:**
1. Check if empty (user pressed Enter) → OK, skip identifier
2. Check regex: `^[a-zA-Z0-9_-]+$`
3. If invalid, show error and re-prompt
4. If valid, preserve case and proceed

**Error message for invalid:**
```
Invalid identifier: "{input}"

Identifiers can only contain:
- Letters (a-z, A-Z)
- Numbers (0-9)
- Hyphens (-)
- Underscores (_)

Examples: MCO-1234, feature-789, PROJ_ABC

Please try again (or press Enter to skip):
```

### Extracting from Filename

**Pattern:** `epic-{identifier}-{nn}-{slug}.md`

**Extraction logic:**
```
filename: "epic-mco-1234-01-auth.md"

1. Remove "epic-" prefix → "mco-1234-01-auth.md"
2. Split by hyphen → ["mco", "1234", "01", "auth", "md"]
3. Find first 2-digit number → "01" at index 2
4. Everything before that index → ["mco", "1234"]
5. Join with hyphen → "mco-1234"
6. Epic number is "01"
```

**Edge cases:**
- `epic-001-auth.md` → identifier: (none), epic_number: "001"
- `epic-mco-1234-simple.md` → Need to look for 2-digit pattern after identifier
- `epic-proj-v2-01-feature.md` → identifier: "proj-v2", epic_number: "01"

**Better extraction pattern:**
```regex
epic-(?P<identifier>[a-zA-Z0-9_-]+)-(?P<number>\d{2,3})-(?P<slug>.+)\.md

If identifier portion contains no letters, it's numeric-only (no identifier):
- "001" → no identifier
- "mco-1234" → has identifier
```

### Extracting from Directory Path

**Pattern:** `stories/epic-{identifier}-{nn}/` or `specs/epic-{identifier}-{nn}/`

**Extraction:**
```
path: ".workflow/stories/epic-mco-1234-01/story-02.md"

1. Extract directory name → "epic-mco-1234-01"
2. Remove "epic-" prefix → "mco-1234-01"
3. Use same logic as filename extraction
4. Result: identifier="mco-1234", epic_number="01"
```

## Propagation Rules

### From PRD to Epic

When creating epics from PRD:
1. Prompt user for identifier
2. If provided, use in epic filenames: `epic-{identifier}-01-{slug}.md`
3. Store in epic frontmatter: `identifier: {identifier}`
4. Store combined epic_id: `epic_id: {identifier}-01`

### From Epic to Stories

When creating stories from epic:
1. Read epic file
2. Check frontmatter for `identifier` and `epic_id`
3. If not in frontmatter, parse from epic filename
4. Create story directory: `stories/epic-{identifier}-{nn}/`
5. Store in story frontmatter

### From Story to Spec

When creating spec from story:
1. Read story file
2. Check frontmatter for `identifier` and `epic_id`
3. If not in frontmatter, parse from story directory path
4. Create spec in: `specs/epic-{identifier}-{nn}/`
5. Store in spec frontmatter

### From Spec to Plan

When executing spec:
1. Read spec file
2. Extract identifier and epic_id from frontmatter or path
3. Use in plan directory: `.planning/{identifier}-{nn}-spec-{id}/`
4. Include in SUMMARY.md for traceability

## Multi-Identifier Projects

**Structure:**
```
.workflow/
├── PRD-mco-1234.md
├── PRD-feature-789.md
├── PRD-bugfix-456.md
├── epics/
│   ├── epic-mco-1234-01-auth.md
│   ├── epic-mco-1234-02-tasks.md
│   ├── epic-feature-789-01-export.md
│   └── epic-bugfix-456-01-perf.md
├── stories/
│   ├── epic-mco-1234-01/
│   ├── epic-mco-1234-02/
│   ├── epic-feature-789-01/
│   └── epic-bugfix-456-01/
└── specs/
    ├── epic-mco-1234-01/
    ├── epic-mco-1234-02/
    ├── epic-feature-789-01/
    └── epic-bugfix-456-01/
```

**No collisions:** Identifiers keep everything separate

## Backward Compatibility

**Old format (no identifier):**
```
epic-001-auth.md → epic_id: 001, no identifier field
stories/epic-001/ → works fine
specs/epic-001/ → works fine
```

**New format (with identifier):**
```
epic-mco-1234-01-auth.md → epic_id: mco-1234-01, identifier: mco-1234
stories/epic-mco-1234-01/ → new subdirectory format
specs/epic-mco-1234-01/ → new subdirectory format
```

**Both coexist:** Skills support both formats

## Implementation Notes

**Always validate user input:**
Use AskUserQuestion with clear error messages

**Always store in frontmatter:**
Even if in filename, also store in YAML for easy parsing

**Always use relative paths:**
Link from child to parent using `../` or `../../`

**Always preserve case:**
If user enters "MCO-1234", don't convert to "mco-1234"

**Always handle missing:**
Identifier is optional - code must work without it
