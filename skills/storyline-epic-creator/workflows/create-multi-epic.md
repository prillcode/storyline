<objective>
Parse PRD/spec into multiple epics, each representing a major feature area or business capability.
Supports optional identifier for tracking (JIRA tickets, etc.).
</objective>

<required_reading>
- templates/epic.md - Epic file structure
- references/epic-patterns.md - Common patterns
- references/identifier-system.md - Identifier format and usage
</required_reading>

<context>
**Identifier:** This workflow receives an optional identifier from the router.
- If provided: Use in filenames and frontmatter (e.g., epic-mco-1234-01-auth.md)
- If not provided: Use numeric format (e.g., epic-001-auth.md)
</context>

<process>

## Step 1: Read Reference Files

Read the following to understand epic structure:
- Read templates/epic.md
- Read references/epic-patterns.md
- Read references/identifier-system.md

## Step 2: Analyze PRD Content

Extract from the PRD:
1. **Core features** - Major capabilities mentioned
2. **User personas** - Who will use this
3. **Business goals** - Why we're building this
4. **Technical scope** - What systems/domains involved
5. **Dependencies** - What depends on what

## Step 3: Identify Epic Boundaries

Group features into epics based on:
- **Business capability** - Authentication, payments, notifications, etc.
- **User journey stage** - Onboarding, core workflow, admin, etc.
- **Technical domain** - Frontend, backend, infrastructure, etc.
- **Dependencies** - What must be built first

**Epic size target:** Each epic should contain 3-8 user stories.

## Step 4: Create Epic Files

For each identified epic:

1. **Determine filename** based on identifier:

   **If identifier provided:**
   - Format: `epic-{identifier}-{nn}-{slug}.md`
   - Example: `epic-mco-1234-01-authentication.md`
   - Use 2-digit numbers: 01, 02, 03, etc.

   **If no identifier:**
   - Format: `epic-{nnn}-{slug}.md`
   - Example: `epic-001-authentication.md`
   - Use 3-digit numbers: 001, 002, 003, etc.

2. **Use template** from templates/epic.md

3. **Fill sections:**
   - Epic ID: `{identifier}-01` or `001`
   - Identifier field: `{identifier}` or omit if none
   - Epic number: `01` or `001`
   - PRD source: Link to PRD file (with identifier if present)
   - Business goal (the "why")
   - User value proposition
   - Success criteria (measurable)
   - Scope (what's in/out)
   - Dependencies on other epics
   - Estimated story count

4. **Write the file** using Write tool to .workflow/epics/

## Step 5: Create Epic Index

Create `.workflow/epics/INDEX.md`:

```markdown
# Epic Index

Generated from: [source PRD path]
{Identifier: [identifier]}  # If provided
Created: [date]
Total epics: [count]

## Epics

### Epic {id}-01: [Title]  # e.g., mco-1234-01 or 001
**Goal:** [One sentence]
**Stories:** ~[count]
**Status:** Ready for story creation

### Epic {id}-02: [Title]
...

## Execution Order

Recommended sequence based on dependencies:
1. Epic {id}-01 (no dependencies)
2. Epic {id}-02 (depends on: 01)
3. Epic {id}-03 (depends on: 01, 02)

## Next Steps

Run `/sl-story-creator .workflow/epics/epic-{id}-01-[slug].md` to begin.
```

**Note:** Use actual epic filenames in the next steps command.

## Step 6: Validate Output

Run validation checks:
- All epic files created successfully
- Epic numbers are sequential
- Each epic has all required sections
- Dependencies are valid (no circular deps)
- Success criteria are measurable
- INDEX.md created

</process>

<output_specification>
Creates:
**With identifier:**
- .workflow/PRD-{identifier}.md (if created via guided mode)
- .workflow/epics/epic-{identifier}-01-{slug}.md
- .workflow/epics/epic-{identifier}-02-{slug}.md
- .workflow/epics/epic-{identifier}-0N-{slug}.md
- .workflow/epics/INDEX.md

**Without identifier:**
- .workflow/PRD-{nnn}.md (if created via guided mode)
- .workflow/epics/epic-001-{slug}.md
- .workflow/epics/epic-002-{slug}.md
- .workflow/epics/epic-00N-{slug}.md
- .workflow/epics/INDEX.md

Each epic file contains:
- YAML frontmatter (epic_id, identifier (if provided), epic_number, title, status)
- Business goal section
- User value section
- Success criteria
- Scope definition
- Dependencies
- Metadata (source PRD, created date)
</output_specification>

<success_criteria>
Complete when:
1. All epic files written to .workflow/epics/
2. INDEX.md created
3. Validation checks pass
4. User informed of next step (/story-creator)
</success_criteria>
