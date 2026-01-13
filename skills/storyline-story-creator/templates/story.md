---
story_id: {NN}
epic_id: {EPIC_ID}
identifier: {IDENTIFIER}
title: {Story Title}
status: ready_for_spec
parent_epic: ../../epics/epic-{EPIC_ID}-{slug}.md
created: {ISO date}
---

# Story {NN}: {Title}

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

**Depends on stories:**
- Story {NUMBER}: {Title} - {Why}

**Enables stories:**
- Story {NUMBER}: {Title} - {What becomes possible}

**No dependencies:** {If applicable}

## Out of Scope

{What is explicitly NOT included in this story}
{Helps prevent scope creep}

## Notes

{Any additional context, open questions, or discussion points}

## Traceability

**Parent epic:** [epic-{EPIC_ID}-{slug}.md](../../epics/epic-{EPIC_ID}-{slug}.md)

**Related stories:** Story {NN}, Story {NN}

**Full chain:**
```
PRD-{identifier}.md
└─ epic-{EPIC_ID}-{slug}.md
   └─ stories/epic-{EPIC_ID}/story-{NN}.md (this file)
      └─ specs/epic-{EPIC_ID}/ (specs created here)
```

---

**Next step:** Run `/sl-spec-story .workflow/stories/epic-{EPIC_ID}/story-{NN}.md`
