<objective>
Create a PRD through guided questions when user doesn't have an existing PRD document.
Then automatically proceed to epic creation.
</objective>

<required_reading>
- templates/prd-template.md (from storyline-setup skill)
- references/identifier-system.md - Identifier validation rules
</required_reading>

<process>

## Step 1: Welcome Message

Display:
```
No PRD file provided. Let's create one together!

I'll guide you through defining your product requirements.
This will take about 2-3 minutes.
```

## Step 2: Prompt for Identifier (Optional)

Use AskUserQuestion or direct prompt:

```
Optional: Provide an identifier for this work

This helps track the work back to your project management system.

Examples:
  • JIRA ticket: MCO-1234
  • Feature code: feature-789
  • Project name: PROJ_ABC

Leave blank to skip (will use numbers like 001, 002).

Identifier:
```

**Validation:**
1. If empty → identifier = None, proceed
2. If provided → validate with regex: `^[a-zA-Z0-9_-]+$`
3. If invalid → show error from references/identifier-system.md and re-prompt
4. If valid → store identifier, proceed

## Step 3: Gather PRD Content

Ask the following questions using AskUserQuestion tool or direct prompts:

### Question 1: Goal/Theme
```
What is the overall goal or theme of this body of work?

(One sentence that captures the "why")

Example: "Enable users to manage their tasks efficiently"
```

Store answer as: `goal`

### Question 2: Target Users
```
Who are the primary users or stakeholders?

(Who will benefit from this?)

Example: "Team leads and project managers"
```

Store answer as: `users`

### Question 3: Core Features
```
What are the core features or capabilities needed?

(List the main things this should do)

Example:
- Create and edit tasks
- Assign tasks to team members
- Track task status
```

Store answer as: `features` (can be multi-line list)

### Question 4: Constraints
```
Are there any constraints or requirements?

(Technical, business, or other limitations)

Example:
- Must work offline
- Must integrate with existing auth system
- Performance: Load under 2 seconds

Leave blank if none.
```

Store answer as: `constraints`

### Question 5: Success Criteria
```
What does success look like?

(How will you know this is done and working?)

Example:
- Users can create 100+ tasks without performance issues
- 80% of team adopts the feature within 1 month
- Task completion rate increases by 20%
```

Store answer as: `success_criteria`

## Step 4: Generate PRD Content

Load templates/prd-template.md from storyline-setup skill (or define inline).

Fill in template:
```markdown
---
prd_id: {identifier or sequential number}
created: {current date}
status: draft
---

# Product Requirements: {goal}

## Overview

**Goal:** {goal}

**Target Users:** {users}

## Success Criteria

{success_criteria}

## Core Features

{features}

## Constraints & Requirements

{constraints}

## Out of Scope

(To be determined during epic breakdown)

## Implementation Notes

(To be determined during epic breakdown)

---

**Next steps:**
1. Break this PRD into epics: `/sl-epic-creator`
2. Generate stories from epics: `/sl-story-creator`
3. Create specs from stories: `/sl-spec-story`
4. Implement specs: `/sl-develop`
```

## Step 5: Determine PRD Filename

**If identifier provided:**
- Filename: `PRD-{identifier}.md`
- Example: `PRD-mco-1234.md`
- Use lowercase for identifier in filename

**If no identifier:**
- Check existing PRD files: `ls .storyline/PRD-*.md`
- Find highest number (e.g., PRD-001.md, PRD-002.md)
- Increment by 1
- Filename: `PRD-{new_number}.md`
- Example: `PRD-001.md`, `PRD-002.md`, etc.

## Step 6: Write PRD File

Use Write tool:
- file_path: `.storyline/PRD-{identifier}.md` or `.storyline/PRD-{number}.md`
- content: Generated PRD content from Step 4

Verify file written:
```bash
ls -la .storyline/PRD-*.md
```

## Step 7: Display Summary

Display:
```
✅ PRD created successfully!

File: .storyline/PRD-{identifier}.md

Summary:
• Goal: {goal}
• Users: {users}
• Core features: {feature count}
{• Identifier: {identifier}}  # Only if provided

Next: Creating epics from this PRD...
```

## Step 8: Transition to Epic Creation

**Important:** Don't exit or wait for user.

Automatically proceed to epic creation:
- Set the PRD file path as if user had provided it
- Call the create-multi-epic workflow
- Pass the identifier along
- Continue seamlessly

**User experience:** User goes from questions → PRD created → epics created in one flow.

</process>

<output_specification>
Creates:
- .storyline/PRD-{identifier}.md OR .storyline/PRD-{number}.md

Contains:
- Frontmatter with prd_id
- All sections filled from user responses
- Ready for epic breakdown

Then transitions to epic creation automatically.
</output_specification>

<success_criteria>
Complete when:
1. PRD file written to .storyline/
2. User informed of what was created
3. Workflow transitions to epic creation (don't stop here)
</success_criteria>

<implementation_notes>

**Keep questions concise:**
Users want to get to coding, not write essays.

**Provide examples:**
Every question should have an example answer.

**Allow "to be determined":**
If user doesn't know something, that's OK - note it and move on.

**Validate identifier:**
Use the validation logic from references/identifier-system.md.

**Sequential numbering:**
If no identifier, use 001, 002, 003 pattern (zero-padded to 3 digits).

**Automatic transition:**
Don't make user run another command - proceed to epic creation.

</implementation_notes>
