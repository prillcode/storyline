---
name: story-creator
description: Generate user stories from epics. Use when converting epic files into detailed user stories following INVEST criteria. Produces structured story files that feed into technical spec creation.
---

<essential_principles>

<principle name="invest_criteria">
All stories must follow INVEST:
- Independent: Can be developed separately
- Negotiable: Details can be refined
- Valuable: Delivers user/business value
- Estimable: Can be sized
- Small: Fits in a sprint
- Testable: Has clear acceptance criteria
</principle>

<principle name="story_is_conversation_starter">
User stories are not complete specifications.
They are conversation starters that get elaborated into technical specs.
Format: "As a [persona], I want [capability], so that [benefit]"
</principle>

<principle name="traceability">
Every story links back to parent epic.
Every story generates technical spec.
Chain: Epic → Story → Spec → Code
</principle>

<principle name="output_structure">
Stories are organized in epic-specific subdirectories OR standalone directory:

**Epic-based stories:**
- With identifier: .storyline/stories/epic-mco-1234-01/story-01.md
- Without identifier: .storyline/stories/epic-001/story-01.md
- Format: .storyline/stories/epic-{epic_id}/story-{nn}.md

**Standalone stories** (no epic required):
- Location: .storyline/stories/.standalone/story-{slug}.md
- Format: .storyline/stories/.standalone/story-fix-login-validation.md
- Best for: bug fixes, small features, quick tasks

Each story includes:
- User story statement
- Acceptance criteria
- Business value
- Technical notes
- Identifier tracking (optional)
- Link to parent epic (if epic-based) or null (if standalone)
</principle>

</essential_principles>

<intake>
**Two modes of story creation:**

**Mode 1: From existing epic** (structured workflow)
Provide the path to your epic file.

Example:
- `.storyline/epics/epic-001-authentication.md`
- `.storyline/epics/epic-002-task-management.md`

**Mode 2: Standalone story** (no epic required)
Use `--standalone` flag OR run without arguments for guided story creation.
Best for: bug fixes, small features, quick tasks

Example:
- `/sl-story-creator --standalone` → Immediately enters standalone mode

**Detection logic:**
- If epic file path provided → Use Mode 1
- If `--standalone` flag provided → Use Mode 2 (skip epic check)
- If no arguments → Check for existing epics:
  - If epics exist → Offer both modes as choice
  - If no epics → Automatically use Mode 2 with explanation
</intake>

<routing>
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

**Then, determine mode:**

**Mode 1: Epic file path provided** (argument is a file path)
1. **Read the epic**: Load the epic document
2. **Read template**: Load templates/story.md
3. **Read patterns**: Load references/story-patterns.md
4. **Execute workflow**: workflows/create-stories-from-epic.md (pass ROOT_DIR to workflow)

**Mode 2a: --standalone flag provided** (explicit standalone request)
1. **Skip epic check entirely** - user explicitly wants standalone mode
2. **Read template**: Load templates/standalone-story.md
3. **Read patterns**: Load references/story-patterns.md
4. **Execute workflow**: workflows/guided-standalone-story.md (pass ROOT_DIR to workflow)

**Mode 2b: No arguments** (auto-detect mode)
1. Check if $ROOT_DIR/epics/ has any epic files
2. If epics exist:
   - Present choice: "Create from epic" or "Create standalone story"
   - If user chooses epic → List epics and switch to Mode 1
   - If user chooses standalone → Continue to guided creation
3. If no epics exist:
   - Explain: "No epics found. I'll guide you through creating a standalone story."
   - Proceed to guided creation
4. **Read template**: Load templates/standalone-story.md
5. **Read patterns**: Load references/story-patterns.md
6. **Execute workflow**: workflows/guided-standalone-story.md (pass ROOT_DIR to workflow)
</routing>

<validation>
**For epic-based stories:**
- [ ] Epic subdirectory created ($ROOT_DIR/stories/epic-{epic_id}/)
- [ ] All stories saved to epic subdirectory
- [ ] Each story follows INVEST criteria
- [ ] Story numbers sequential (01, 02, 03)
- [ ] Each story has acceptance criteria
- [ ] All stories link back to parent epic
- [ ] Identifier stored in frontmatter (if present)
- [ ] Created INDEX.md in epic subdirectory

**For standalone stories:**
- [ ] Standalone directory created ($ROOT_DIR/stories/.standalone/)
- [ ] Story saved with descriptive slug filename
- [ ] Story follows INVEST criteria
- [ ] Story has acceptance criteria
- [ ] Frontmatter indicates story_type: standalone
- [ ] parent_epic field set to null
- [ ] Optional identifier stored (e.g., JIRA ticket)
- [ ] Updated INDEX.md in .standalone/ directory (if exists)
</validation>

<success_criteria>
**Epic-based stories:**
1. All stories written to $ROOT_DIR/stories/epic-{epic_id}/ (supports both .storyline/ and .workflow/)
2. Each story validates against INVEST criteria
3. INDEX.md created in epic subdirectory
4. User can proceed to spec creation with /sl-spec-story

**Standalone stories:**
1. Story written to $ROOT_DIR/stories/.standalone/story-{slug}.md
2. Story validates against INVEST criteria
3. Frontmatter correctly set (story_type: standalone, parent_epic: null)
4. User can proceed to spec creation with /sl-spec-story
</success_criteria>

<reference_index>
## Domain Knowledge

All in `references/`:

**story-patterns.md** - Common story patterns and INVEST examples
**acceptance-criteria.md** - How to write good acceptance criteria
</reference_index>

<workflows_index>
## Workflows

All in `workflows/`:

| Workflow | Purpose |
|----------|---------|
| create-stories-from-epic.md | Generate stories from epic file |
| guided-standalone-story.md | Create standalone story through guided prompts |
| validate-story.md | Check story quality and INVEST compliance |
</workflows_index>
