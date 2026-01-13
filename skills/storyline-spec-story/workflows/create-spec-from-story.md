<objective>
Create technical specification from user story, with flexible spec strategies for different story complexities.
Supports epic subdirectories and identifier propagation.
</objective>

<required_reading>
- templates/spec.md - Spec file structure
- ../storyline-epic-creator/references/identifier-system.md - Identifier extraction
</required_reading>

<process>

## Step 1: Read Story and Extract Context

1. Read the story file provided by user
2. Read templates/spec.md

**Extract from story:**
- Story content (user story, acceptance criteria, etc.)
- From frontmatter: `story_id`, `epic_id`, `identifier`
- If frontmatter missing, parse from file path

**Example path:** `.storyline/stories/epic-mco-1234-01/story-02.md`
- Epic ID: `mco-1234-01`
- Story ID: `02`
- Identifier: `mco-1234`

## Step 2: Prompt for Spec Strategy

Use AskUserQuestion tool:

```
Question: "Choose spec strategy for story-{story_id}:"
Options:
  1. Simple story - create single spec (spec-{story_id}.md)
  2. Complex story - will need multiple specs (spec-story{story_id}-01.md, spec-story{story_id}-02.md...)
  3. Combine with other stories - combine into one spec (e.g., spec-stories-{story_ids}-combined.md)
```

**Store user choice as:** `spec_strategy` (simple|complex|combined)

## Step 3: Determine Spec Filename

Based on strategy:

**Simple:**
- Format: `spec-{story_id}.md`
- Example: `spec-02.md`
- Full path: `.storyline/specs/epic-{epic_id}/spec-02.md`

**Complex:**
- Prompt: "This is part {N} of story-{story_id}. What does this part cover?"
- Format: `spec-story{story_id}-{part_nn}.md`
- Example: `spec-story02-01.md`, `spec-story02-02.md`
- Full path: `.storyline/specs/epic-{epic_id}/spec-story02-01.md`

**Combined:**
- Prompt: "Which other stories to combine? (comma-separated, e.g., 03,04)"
- Format: `spec-stories-{ids}-combined.md`
- Example: `spec-stories-02-03-combined.md`
- Full path: `.storyline/specs/epic-{epic_id}/spec-stories-02-03-combined.md`

## Step 4: Read Parent Epic

Read the parent epic file for additional context:
- Path from story frontmatter: `parent_epic` field
- Or construct: `.storyline/epics/epic-{epic_id}-*.md`

Extract business context, technical considerations, constraints.

## Step 5: Create Epic Subdirectory

```bash
mkdir -p .storyline/specs/epic-{epic_id}/
```

Examples:
- `.storyline/specs/epic-mco-1234-01/`
- `.storyline/specs/epic-001/`

## Step 6: Generate Spec Content

Using the template and story content:

1. **Frontmatter:**
   - `spec_id`: Based on strategy (e.g., `02`, `story02-01`, `stories-02-03`)
   - `story_ids`: Array of story IDs (e.g., `[02]` or `[02, 03]`)
   - `epic_id`: From story
   - `identifier`: From story (if present)
   - `complexity`: simple|split|combined
   - `parent_story`: Relative path to story file

2. **Content sections:**
   - Technical approach
   - Files to modify/create
   - API contracts
   - Data models
   - Testing requirements
   - Acceptance criteria verification

3. **Map story acceptance criteria** to technical verification steps

## Step 7: Write Spec File

Use Write tool:
- file_path: `.storyline/specs/epic-{epic_id}/{filename}`
- content: Generated spec

Verify with ls:
```bash
ls -la .storyline/specs/epic-{epic_id}/
```

## Step 8: Display Success Message

```
✅ Spec created successfully!

File: .storyline/specs/epic-{epic_id}/{filename}
Strategy: {simple|complex|combined}
Stories: {story_ids}

Next: Implement this spec
  /sl-develop .storyline/specs/epic-{epic_id}/{filename}
```

</process>

<output_specification>
Creates:
- .storyline/specs/epic-{epic_id}/ (directory, if not exists)
- .storyline/specs/epic-{epic_id}/spec-{nn}.md (simple)
- OR .storyline/specs/epic-{epic_id}/spec-story{nn}-{part}.md (complex)
- OR .storyline/specs/epic-{epic_id}/spec-stories-{ids}-combined.md (combined)

Each spec file contains:
- YAML frontmatter with spec_id, story_ids, epic_id, identifier, complexity
- Technical approach
- File changes
- API contracts
- Testing requirements
- Traceability links
</output_specification>

<success_criteria>
Complete when:
1. Spec file written to .storyline/specs/epic-{epic_id}/
2. Filename follows chosen strategy
3. All acceptance criteria from story mapped to verification
4. User informed of next step (/sl-develop)
</success_criteria>
