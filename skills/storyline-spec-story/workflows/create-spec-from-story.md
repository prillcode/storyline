<objective>
Create technical specification from user story, with flexible spec strategies for different story complexities.
Supports epic subdirectories, standalone stories, identifier propagation, and optional file references for additional context.
</objective>

<required_reading>
- templates/spec.md - Spec file structure
- ../storyline-epic-creator/references/identifier-system.md - Identifier extraction
</required_reading>

<process>

## Step 1: Read Story and Detect Type

1. Read the story file provided by user
2. Read templates/spec.md

**Detect story type:**
- Check if path contains `/.standalone/` OR
- Check frontmatter for `story_type: standalone`
- If either is true → **Standalone story** (go to Step 1A)
- Otherwise → **Epic-based story** (continue to Step 1B)

### Step 1A: Extract Standalone Story Context

**For standalone stories:**
- Story content (user story, acceptance criteria, etc.)
- From frontmatter: `story_id`, `work_type`, `identifier`, `title`
- Extract slug from filename: `story-{slug}.md` → `{slug}`

**Example path:** `.storyline/stories/.standalone/story-fix-login-validation.md`
- Story slug: `fix-login-validation`
- Story type: `standalone`
- Parent epic: `null`

**Continue to Step 1C (file references), then Step 3A (standalone spec handling)**

### Step 1B: Extract Epic-Based Story Context

**For epic-based stories:**
- Story content (user story, acceptance criteria, etc.)
- From frontmatter: `story_id`, `epic_id`, `identifier`
- If frontmatter missing, parse from file path

**Example path:** `.storyline/stories/epic-mco-1234-01/story-02.md`
- Epic ID: `mco-1234-01`
- Story ID: `02`
- Identifier: `mco-1234`

**Continue to Step 1C**

## Step 1C: Prompt for File References (Both Story Types)

**This step applies to both standalone and epic-based stories.**

Use AskUserQuestion tool:

```
Question: "Are there existing files this story will modify or should reference? Only include files that provide additional context for the feature/fix outlined in this story."
Header: "File refs"
Options:
  - Yes - I have files to reference
  - No - Proceed without file references
```

**If user selects "No":**
- Set `referenced_files` to empty array
- Continue to next step (Step 2 for epic-based, Step 3A for standalone)

**If user selects "Yes":**
1. Prompt: "Enter file paths (relative to project root), one per line. Examples: src/components/Button.tsx, lib/utils.ts"
2. Collect file paths from user input
3. For each valid file path:
   - Read the file using Read tool
   - Extract relevant context:
     - For TypeScript/JavaScript: exports, interfaces, type definitions, key function signatures
     - For other files: main structure, key definitions
   - Store as `{ path: string, context: string }` object
4. Store array as `referenced_files`

**File context extraction guidance:**
- Focus on exports, interfaces, and function signatures
- Include relevant type definitions
- Note key patterns or conventions used in the file
- Keep context concise but informative (not entire file contents)

**Continue to Step 2 (epic-based) or Step 3A (standalone)**

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

## Step 3: Determine Spec Filename (Epic-Based)

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

## Step 3A: Determine Spec Filename (Standalone)

**For standalone stories:**
- No strategy prompt needed (always simple: 1 story → 1 spec)
- Format: `spec-{slug}.md` (matches story slug)
- Example: `spec-fix-login-validation.md`
- Full path: `$ROOT_DIR/specs/.standalone/spec-{slug}.md`

**Continue to Step 5A** (skip Step 4 - no parent epic to read)

## Step 4: Read Parent Epic

Read the parent epic file for additional context:
- Path from story frontmatter: `parent_epic` field
- Or construct: `.storyline/epics/epic-{epic_id}-*.md`

Extract business context, technical considerations, constraints.

## Step 5: Create Epic Subdirectory

**For epic-based specs:**
```bash
mkdir -p $ROOT_DIR/specs/epic-{epic_id}/
```

Examples:
- `.storyline/specs/epic-mco-1234-01/`
- `.storyline/specs/epic-001/`

**Continue to Step 6**

## Step 5A: Create Standalone Subdirectory

**For standalone specs:**
```bash
mkdir -p $ROOT_DIR/specs/.standalone/
```

Example:
- `.storyline/specs/.standalone/`

**Continue to Step 6A**

## Step 6: Generate Spec Content

Using the template, story content, and referenced files (if any):

1. **Frontmatter:**
   - `spec_id`: Based on strategy (e.g., `02`, `story02-01`, `stories-02-03`)
   - `story_ids`: Array of story IDs (e.g., `[02]` or `[02, 03]`)
   - `epic_id`: From story
   - `identifier`: From story (if present)
   - `complexity`: simple|split|combined
   - `parent_story`: Relative path to story file
   - `referenced_files`: Array of file paths (if any were provided)

2. **Content sections:**
   - Technical approach
   - Files to modify/create
   - API contracts
   - Data models
   - Testing requirements
   - Acceptance criteria verification

3. **If `referenced_files` is not empty**, add section:
   ```markdown
   ## Referenced Files

   The following existing files provide context for this implementation:

   ### `{file_path}`
   {extracted context: exports, interfaces, key functions}

   ### `{file_path_2}`
   {extracted context}
   ```

4. **Use file context to inform spec:**
   - Reference existing patterns and conventions from the files
   - Identify specific functions/components to modify
   - Note existing interfaces to extend or implement
   - Align new code with existing code style

5. **Map story acceptance criteria** to technical verification steps

## Step 6A: Generate Spec Content (Standalone)

**For standalone stories:**

Using the template, story content, and referenced files (if any):

1. **Frontmatter:**
   - `spec_id`: Same as story slug (e.g., `fix-login-validation`)
   - `story_id`: From story frontmatter
   - `story_type`: `standalone`
   - `work_type`: From story (bug_fix, small_feature, enhancement, task)
   - `identifier`: From story (if present) or null
   - `parent_story`: Relative path to story file
   - `parent_epic`: `null` (no parent epic)
   - `referenced_files`: Array of file paths (if any were provided)

2. **Content sections:**
   - Technical approach
   - Files to modify/create
   - API contracts (if applicable)
   - Data models (if applicable)
   - Testing requirements
   - Acceptance criteria verification

3. **If `referenced_files` is not empty**, add section:
   ```markdown
   ## Referenced Files

   The following existing files provide context for this implementation:

   ### `{file_path}`
   {extracted context: exports, interfaces, key functions}
   ```

4. **Use file context to inform spec:**
   - Reference existing patterns and conventions from the files
   - Identify specific functions/components to modify
   - Note existing interfaces to extend or implement
   - Align new code with existing code style

5. **Map story acceptance criteria** to technical verification steps

6. **Traceability:** Update to reflect standalone structure
   ```
   Standalone story (adhoc work)
   └─ .storyline/stories/.standalone/story-{slug}.md
      └─ .storyline/specs/.standalone/spec-{slug}.md (this file)
   ```

## Step 7: Write Spec File

**For epic-based specs:**
Use Write tool:
- file_path: `$ROOT_DIR/specs/epic-{epic_id}/{filename}`
- content: Generated spec

Verify with ls:
```bash
ls -la $ROOT_DIR/specs/epic-{epic_id}/
```

## Step 7A: Write Spec File (Standalone)

**For standalone specs:**
Use Write tool:
- file_path: `$ROOT_DIR/specs/.standalone/spec-{slug}.md`
- content: Generated spec

Verify with ls:
```bash
ls -la $ROOT_DIR/specs/.standalone/
```

## Step 8: Display Success Message

**For epic-based specs:**
```
✅ Spec created successfully!

File: $ROOT_DIR/specs/epic-{epic_id}/{filename}
Strategy: {simple|complex|combined}
Stories: {story_ids}

Next: Implement this spec
  /sl-develop $ROOT_DIR/specs/epic-{epic_id}/{filename}
```

**For standalone specs:**
```
✅ Standalone spec created successfully!

File: $ROOT_DIR/specs/.standalone/spec-{slug}.md
Type: {work_type}
Story: {title}

Next: Implement this spec
  /sl-develop $ROOT_DIR/specs/.standalone/spec-{slug}.md
```

</process>

<output_specification>
**Epic-based specs:**
- $ROOT_DIR/specs/epic-{epic_id}/ (directory, if not exists)
- $ROOT_DIR/specs/epic-{epic_id}/spec-{nn}.md (simple)
- OR $ROOT_DIR/specs/epic-{epic_id}/spec-story{nn}-{part}.md (complex)
- OR $ROOT_DIR/specs/epic-{epic_id}/spec-stories-{ids}-combined.md (combined)

Each epic-based spec contains:
- YAML frontmatter with spec_id, story_ids, epic_id, identifier, complexity
- Technical approach, file changes, API contracts, testing, traceability links

**Standalone specs:**
- $ROOT_DIR/specs/.standalone/ (directory, if not exists)
- $ROOT_DIR/specs/.standalone/spec-{slug}.md

Each standalone spec contains:
- YAML frontmatter with spec_id, story_id, story_type: standalone, work_type, identifier
- Technical approach, file changes, API contracts, testing, traceability links
</output_specification>

<success_criteria>
**Epic-based specs complete when:**
1. Spec file written to $ROOT_DIR/specs/epic-{epic_id}/
2. Filename follows chosen strategy
3. All acceptance criteria from story mapped to verification
4. User informed of next step (/sl-develop)

**Standalone specs complete when:**
1. Spec file written to $ROOT_DIR/specs/.standalone/spec-{slug}.md
2. Filename matches parent story slug
3. All acceptance criteria from story mapped to verification
4. User informed of next step (/sl-develop)
</success_criteria>
