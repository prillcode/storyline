---
name: epic-creator
description: Parse PRDs and technical specs into manageable epics. Use when converting product requirements documents or technical specifications into epic-level work items. Produces structured epic files that feed into story creation.
---

<essential_principles>

<principle name="epic_is_theme">
An epic is a theme or large feature area, not a task list.
Epics group related user stories under a common business goal.
</principle>

<principle name="right_sized_epics">
Epics should be:
- Too large for a single sprint (requires multiple stories)
- Small enough to ship in 2-4 weeks
- Focused on a single business capability
</principle>

<principle name="traceability">
Every epic links back to the source PRD/spec.
Every epic generates multiple stories.
Full chain: PRD → Epic → Story → Spec → Code
</principle>

<principle name="output_structure">
Epics are markdown files in .storyline/epics/:
- With identifier: epic-mco-1234-01-authentication.md
- Without identifier: epic-001-authentication.md

Format: epic-{identifier}-{nn}-{slug}.md

Each epic includes:
- Business goal (why this matters)
- Success criteria (what done looks like)
- User value (who benefits and how)
- Scope boundaries (what's in/out)
- Related epics (dependencies)
- Identifier tracking (optional, for JIRA/etc)
</principle>

</essential_principles>

<intake>
**Epic creation from PRD/spec**

**Two modes:**

1. **With existing PRD** - Provide the path to your PRD or technical spec document:
   - `docs/PRD.md`
   - `.storyline/technical-spec.md`
   - `requirements/product-requirements.md`

2. **Guided mode (no PRD)** - Run without arguments:
   - `/sl-epic-creator`
   - I'll guide you through creating a PRD with questions

**Wait for input before proceeding.**
</intake>

<routing>
After receiving input:

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

**Case 1: No arguments provided (guided mode)**
→ workflows/guided-prd-creation.md
(Creates PRD through questions, then proceeds to epic creation)

**Case 2: File path provided**
1. **Read the PRD/spec**: Load the document using Read tool
2. **Prompt for identifier**: Ask user for optional tracking identifier (see references/identifier-system.md)
   - "Optional: Provide an identifier for this work (e.g., JIRA ticket MCO-1234):"
   - Validate: alphanumeric + hyphens + underscores only
   - Can skip (press Enter)
3. **Analyze complexity**: Determine if single-epic or multi-epic
4. **Route to workflow**:
   - Small feature (1-2 main capabilities) → workflows/create-single-epic.md (if exists)
   - Large project (3+ main capabilities) → workflows/create-multi-epic.md
   - Pass identifier AND ROOT_DIR to workflow

**Automatic routing based on content analysis, no user prompt needed for epic count.**
</routing>

<validation>
Before completing, verify:
- [ ] All epics saved to $ROOT_DIR/epics/ (use detected directory from routing)
- [ ] Each epic follows template structure
- [ ] Epic numbers sequential (01, 02, 03) with identifier if provided
- [ ] Each epic has clear business goal
- [ ] Success criteria are measurable
- [ ] Dependencies identified
- [ ] Identifier stored in frontmatter (if provided)
- [ ] Created epic index file ($ROOT_DIR/epics/INDEX.md)
</validation>

<success_criteria>
Epic creation successful when:
1. All epics written to $ROOT_DIR/epics/ (supports both .storyline/ and .workflow/)
2. Each epic file validates against template
3. INDEX.md created with epic summary
4. User can proceed to story creation with /sl-story-creator
</success_criteria>

<reference_index>
## Domain Knowledge

All in `references/`:

**epic-patterns.md** - Common epic patterns and anti-patterns
**prd-parsing.md** - How to extract epics from different PRD formats
**scope-sizing.md** - Guidelines for right-sizing epics
**identifier-system.md** - Identifier format rules, validation, and propagation
</reference_index>

<workflows_index>
## Workflows

All in `workflows/`:

| Workflow | Purpose |
|----------|---------|
| guided-prd-creation.md | Create PRD through questions (no existing PRD) |
| create-multi-epic.md | Complex project → multiple epics (most common) |
| create-single-epic.md | Simple feature → one epic (if exists) |
</workflows_index>
