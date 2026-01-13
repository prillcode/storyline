# Workflow: Guided Standalone Story Creation

## Purpose
Guide user through creating a standalone story for bug fixes, small features, or quick tasks that don't require a full epic.

## Context
- ROOT_DIR: Passed from router (.storyline or .workflow)
- Template: templates/standalone-story.md loaded
- Patterns: references/story-patterns.md loaded

## Workflow Steps

### Step 1: Explain Standalone Stories

Output to user:
```
I'll guide you through creating a standalone story.

Standalone stories are ideal for:
- Bug fixes
- Small features that don't need an epic
- Quick enhancements or improvements
- Individual tasks

This story will be created in {ROOT_DIR}/stories/.standalone/
and can proceed directly to spec creation just like epic-based stories.
```

### Step 2: Gather Story Information

**Question 1: Work Type**
```
What type of work is this?
1. Bug fix - Correcting existing functionality
2. Small feature - New capability that doesn't need an epic
3. Enhancement - Improvement to existing feature
4. Task - Technical work or chore

Enter number (1-4):
```

Store as: work_type (bug_fix, small_feature, enhancement, task)

**Question 2: Title**
```
What's a brief title for this work?
(e.g., "Fix login validation error", "Add export to CSV button")

Title:
```

Store as: title
Generate slug: Convert to lowercase, replace spaces with hyphens, remove special chars
Example: "Fix login validation error" → "fix-login-validation-error"

**Question 3: User Persona**
```
Who is the primary user affected by this work?
(e.g., "end user", "admin", "developer", "system operator")

User persona:
```

Store as: persona

**Question 4: Capability/Goal**
```
What capability or outcome does this provide?
(Complete the sentence: "I want to...")

Capability:
```

Store as: capability

**Question 5: Business Value**
```
What's the business value or benefit?
(Complete the sentence: "so that...")

Benefit:
```

Store as: benefit

**Question 6: Acceptance Criteria**
```
Describe the acceptance criteria.
I'll help structure this as Given/When/Then scenarios.

What's the main happy path scenario?
```

Prompt for:
- Initial context (Given)
- Action (When)
- Expected outcome (Then)

Then ask: "Any additional scenarios? (edge cases, validations, error handling)"
Collect 1-2 more scenarios if provided.

Store as: acceptance_criteria array

**Question 7: Optional Identifier**
```
Optional: Do you have a tracking identifier for this work?
(e.g., JIRA ticket like "PROJ-123", GitHub issue "#456", or press Enter to skip)

Identifier:
```

Store as: identifier (or null if skipped)

### Step 3: Generate Story Content

Using the template standalone-story.md, populate:
- story_id: {slug}
- story_type: standalone
- work_type: {work_type from Q1}
- identifier: {identifier from Q7 or null}
- title: {title from Q2}
- status: ready_for_spec
- parent_epic: null
- created: {current ISO date}

Populate body sections:
- User Story: "As a {persona}, I want {capability}, so that {benefit}"
- Acceptance Criteria: Format scenarios from Q6 in Given/When/Then
- Business Value: Expand on benefit from Q5
- Technical Considerations: Leave template placeholders
- Dependencies: Set to "No dependencies" by default
- Out of Scope: Leave for user to fill
- Notes: Empty
- Traceability: Update with actual slug

### Step 4: Create Directory and Save Story

```bash
mkdir -p "$ROOT_DIR/stories/.standalone"
```

Save story to: `$ROOT_DIR/stories/.standalone/story-{slug}.md`

### Step 5: Create or Update INDEX.md

Check if `$ROOT_DIR/stories/.standalone/INDEX.md` exists.

If not, create it:
```markdown
# Standalone Stories

Stories for adhoc work (bug fixes, small features, quick tasks) that don't require a full epic.

## Stories

- [story-{slug}.md](story-{slug}.md) - {title} ({work_type}) - {status}
```

If exists, append new entry to ## Stories section.

### Step 6: Validate Story

Verify:
- [ ] File saved to correct location
- [ ] Frontmatter has all required fields
- [ ] story_type set to "standalone"
- [ ] parent_epic set to null
- [ ] User story follows "As a/I want/so that" format
- [ ] At least one acceptance criteria scenario present
- [ ] Slug is URL-friendly (lowercase, hyphens, no special chars)

### Step 7: Report Success to User

```
✅ Standalone story created successfully!

**Location:** {ROOT_DIR}/stories/.standalone/story-{slug}.md
**Type:** {work_type}
**Title:** {title}
{**Identifier:** {identifier}} (if provided)

**Next steps:**
1. Review and refine the story file
2. Create technical spec: /sl-spec-story {ROOT_DIR}/stories/.standalone/story-{slug}.md
3. Implement: /sl-develop {ROOT_DIR}/specs/.standalone/spec-{slug}.md
```

## Error Handling

### No ROOT_DIR
If ROOT_DIR not detected:
```
Error: No Storyline project found.
Run /sl-setup init first to create the project structure.
```

### Invalid slug
If slug generation produces empty or invalid result:
```
Error: Could not generate valid filename from title.
Please use alphanumeric characters and spaces only.
```

### File already exists
If story file already exists:
```
Warning: A story with this name already exists:
{ROOT_DIR}/stories/.standalone/story-{slug}.md

Options:
1. Choose a different title
2. Overwrite existing story (use caution!)

What would you like to do?
```

## Success Criteria

Standalone story created when:
1. File exists at `$ROOT_DIR/stories/.standalone/story-{slug}.md`
2. Frontmatter correctly set (story_type: standalone, parent_epic: null)
3. User story statement populated
4. At least one acceptance criteria scenario present
5. INDEX.md updated with new story
6. Story validates against INVEST criteria
7. User informed of next steps (/sl-spec-story)
