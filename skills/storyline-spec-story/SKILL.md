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
Specs are organized in epic-specific subdirectories:
- With identifier: .workflow/specs/epic-mco-1234-01/spec-01.md
- Without identifier: .workflow/specs/epic-001/spec-01.md

Format: .workflow/specs/epic-{epic_id}/spec-{nn}.md

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

Provide the path to your story file.

Example:
- `.workflow/stories/epic-mco-1234-01/story-01.md`
- `.workflow/stories/epic-001/story-02.md`

You'll be prompted to choose a spec strategy:
- Simple: One story → one spec
- Complex: One story → multiple specs (for large stories)
- Combined: Multiple stories → one spec (for small related stories)

**Wait for file path before proceeding.**
</intake>

<routing>
After receiving story file path:

1. **Read the story**: Load the story document
2. **Extract identifier and epic_id**: From story frontmatter or path
3. **Prompt for spec strategy**: Ask user which approach to use
4. **Read parent epic**: For additional context
5. **Read template**: Load templates/spec.md
6. **Execute workflow**: workflows/create-spec-from-story.md
   - Pass spec strategy to workflow
   - Workflow determines filename based on strategy

**Single workflow with strategy parameter.**
</routing>

<validation>
Before completing, verify:
- [ ] Epic subdirectory created (.workflow/specs/epic-{epic_id}/)
- [ ] Spec saved to epic subdirectory
- [ ] Spec filename follows chosen strategy
- [ ] All files to change identified
- [ ] API contracts defined
- [ ] Testing requirements specified
- [ ] Links to parent story and epic
- [ ] Identifier stored in frontmatter (if present)
- [ ] Acceptance criteria mapped to verification steps
</validation>

<success_criteria>
Spec creation successful when:
1. Spec file written to .workflow/specs/epic-{epic_id}/
2. Filename follows spec strategy (simple/complex/combined)
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
