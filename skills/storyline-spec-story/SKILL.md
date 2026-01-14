---
name: spec-story
description: Create technical specifications from user stories. Use when converting story files into detailed technical specs that can be executed. Produces structured spec files ready for implementation.
---

<essential_principles>

<principle name="spec_is_executable">
Technical specs are implementation-ready documents.
They contain enough detail for Claude to execute without ambiguity.
Specs answer: What files change? What logic is added? How is it tested?
</principle>

<principle name="spec_bridges_story_and_code">
Specs translate user needs into technical decisions.
Story says WHAT user wants. Spec says HOW we'll build it.
</principle>

<principle name="traceability">
Every spec links to parent story and epic.
Every spec becomes a PLAN.md for execution.
Chain: Epic → Story → Spec → Code
</principle>

<principle name="output_structure">
Specs are organized in epic-specific subdirectories OR standalone directory:

**Epic-based specs:**
- With identifier: .storyline/specs/epic-mco-1234-01/spec-01.md
- Without identifier: .storyline/specs/epic-001/spec-01.md
- Format: .storyline/specs/epic-{epic_id}/spec-{nn}.md

**Standalone specs** (from standalone stories):
- Location: .storyline/specs/.standalone/spec-{slug}.md
- Format: .storyline/specs/.standalone/spec-fix-login-validation.md
- Matches parent story slug for easy tracing

Each spec includes:
- Technical approach
- Files to modify/create
- API contracts
- Database changes
- Testing requirements
- Success verification
- Identifier tracking (optional)
</principle>

<principle name="spec_strategies">
Three spec strategies based on story complexity:
- Simple (1 story → 1 spec): spec-01.md, spec-02.md
- Complex (1 story → multiple specs): spec-story02-01.md, spec-story02-02.md
- Combined (multiple stories → 1 spec): spec-stories-02-03-combined.md

User chooses strategy when creating spec.
</principle>

</essential_principles>

<intake>
**Technical spec creation from story**

Provide the path to your story file (epic-based or standalone).

**Epic-based stories:**
- `.storyline/stories/epic-mco-1234-01/story-01.md`
- `.storyline/stories/epic-001/story-02.md`

**Standalone stories:**
- `.storyline/stories/.standalone/story-fix-login-validation.md`
- `.storyline/stories/.standalone/story-add-export-button.md`

**After reading the story**, you'll be prompted to optionally provide existing files for context:
- Components that will be modified
- Related source files
- Type definitions or interfaces

**For epic-based stories**, you'll be prompted to choose a spec strategy:
- Simple: One story → one spec
- Complex: One story → multiple specs (for large stories)
- Combined: Multiple stories → one spec (for small related stories)

**For standalone stories**, specs are always simple (1 story → 1 spec).

**Wait for file path before proceeding.**
</intake>

<routing>
After receiving story file path:

**First, detect project directory** (checks .storyline/ first, falls back to .workflow/):
```bash
if [ -d ".storyline" ]; then
  ROOT_DIR=".storyline"
elif [ -d ".workflow" ]; then
  ROOT_DIR=".workflow"
else
  echo "No Storyline project found. Run /sl-setup init first."
  exit 1
fi
```

Use `$ROOT_DIR` in all file paths throughout the workflow.

**Second, detect story type** from file path or frontmatter:
- If path contains `/.standalone/` OR frontmatter has `story_type: standalone` → Standalone story
- Otherwise → Epic-based story

**For standalone stories:**
1. **Read the story**: Load the story document
2. **Extract slug**: From filename (e.g., `story-fix-login.md` → `fix-login`)
3. **Prompt for file references**: Ask if existing files should be referenced (optional)
4. **Read template**: Load templates/spec.md
5. **Execute workflow**: workflows/create-spec-from-story.md
   - Pass ROOT_DIR, story_type=standalone, and referenced_files (if any)
   - Spec strategy is always "simple" (no prompt needed)
   - Spec location: `$ROOT_DIR/specs/.standalone/spec-{slug}.md`

**For epic-based stories:**
1. **Read the story**: Load the story document
2. **Extract identifier and epic_id**: From story frontmatter or path
3. **Prompt for file references**: Ask if existing files should be referenced (optional)
4. **Prompt for spec strategy**: Ask user which approach to use
5. **Read parent epic**: For additional context
6. **Read template**: Load templates/spec.md
7. **Execute workflow**: workflows/create-spec-from-story.md
   - Pass spec strategy, ROOT_DIR, and referenced_files (if any)
   - Workflow determines filename based on strategy

**File reference prompt** (used in both flows):
- Ask: "Are there existing files this story will modify or should reference? Only include files that provide additional context for the feature/fix outlined in this story."
- Options: Yes / No
- If Yes: "Enter file paths (relative to project root), one per line. Press Enter on empty line when done."
- Read each file and extract relevant context (exports, interfaces, key functions)
- Pass file contexts to workflow for inclusion in spec

**Single workflow with strategy, story type, and file references parameters.**
</routing>

<validation>
**For epic-based specs:**
- [ ] Epic subdirectory created ($ROOT_DIR/specs/epic-{epic_id}/)
- [ ] Spec saved to epic subdirectory
- [ ] Spec filename follows chosen strategy
- [ ] All files to change identified
- [ ] API contracts defined
- [ ] Testing requirements specified
- [ ] Links to parent story and epic
- [ ] Identifier stored in frontmatter (if present)
- [ ] Acceptance criteria mapped to verification steps

**For standalone specs:**
- [ ] Standalone directory created ($ROOT_DIR/specs/.standalone/)
- [ ] Spec saved with matching slug (spec-{slug}.md)
- [ ] All files to change identified
- [ ] API contracts defined
- [ ] Testing requirements specified
- [ ] Links to parent story (no epic link needed)
- [ ] Frontmatter indicates story_type: standalone
- [ ] Acceptance criteria mapped to verification steps
</validation>

<success_criteria>
**Epic-based specs:**
1. Spec file written to $ROOT_DIR/specs/epic-{epic_id}/ (supports both .storyline/ and .workflow/)
2. Filename follows spec strategy (simple/complex/combined)
3. Technical approach is clear and executable
4. All file changes documented
5. Testing requirements defined
6. User can proceed to implementation with /sl-develop

**Standalone specs:**
1. Spec file written to $ROOT_DIR/specs/.standalone/spec-{slug}.md
2. Slug matches parent story for easy tracing
3. Technical approach is clear and executable
4. All file changes documented
5. Testing requirements defined
6. User can proceed to implementation with /sl-develop
</success_criteria>

<reference_index>
## Domain Knowledge

All in `references/`:

**spec-patterns.md** - Technical spec patterns and examples
**testing-requirements.md** - How to specify testing needs
</reference_index>

<workflows_index>
## Workflows

All in `workflows/`:

| Workflow | Purpose |
|----------|---------|
| create-spec-from-story.md | Generate technical spec from story |
| validate-spec.md | Check spec completeness and executability |
</workflows_index>
