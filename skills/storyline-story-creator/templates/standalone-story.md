---
story_id: {slug}
story_type: standalone
work_type: {bug_fix|small_feature|enhancement|task}
identifier: {IDENTIFIER or null}
title: {Story Title}
status: ready_for_spec
parent_epic: null
created: {ISO date}
---

# Standalone Story: {Title}

## User Story

**As a** {user persona},
**I want** {capability or feature},
**so that** {business value or user benefit}.

## Acceptance Criteria

### Scenario 1: {Happy path scenario}
**Given** {initial context or state}
**When** {action or event}
**Then** {expected outcome}
**And** {additional outcome}

### Scenario 2: {Edge case or validation}
**Given** {initial context}
**When** {action}
**Then** {expected outcome}

### Scenario 3: {Error handling}
**Given** {error condition}
**When** {action}
**Then** {error handling behavior}

## Business Value

**Why this matters:** {Clear explanation of business value}

**Impact:** {Who benefits and how}

**Success metric:** {How we'll measure success}

## Technical Considerations

{High-level technical notes that inform the spec}

**Potential approaches:**
- {Approach 1}
- {Approach 2}

**Constraints:**
- {Constraint 1}
- {Constraint 2}

**Data requirements:**
- {Data needed}

## Dependencies

**Depends on:**
- {Dependency 1}
- {Dependency 2}

**No dependencies:** {If applicable}

## Out of Scope

{What is explicitly NOT included in this story}
{Helps prevent scope creep}

## Notes

{Any additional context, open questions, or discussion points}

## Traceability

**Story type:** Standalone (no parent epic)

**Identifier:** {IDENTIFIER or "N/A"}

**Location:** `.storyline/stories/.standalone/story-{slug}.md`

**Chain:**
```
Standalone story (adhoc work)
└─ .storyline/stories/.standalone/story-{slug}.md (this file)
   └─ .storyline/specs/.standalone/spec-{slug}.md (spec created here)
```

---

**Next step:** Run `/sl-spec-story .storyline/stories/.standalone/story-{slug}.md`
