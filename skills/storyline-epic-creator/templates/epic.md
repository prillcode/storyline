---
epic_id: {EPIC_ID}
identifier: {IDENTIFIER}
epic_number: {NN}
title: {Epic Title}
status: ready_for_stories
prd_source: {Path to PRD}
created: {ISO date}
---

# Epic {EPIC_ID}: {Title}

## Business Goal

{Why are we building this? What business value does it provide?}

**Target outcome:** {Specific, measurable business result}

## User Value

**Who benefits:** {User persona(s)}

**How they benefit:** {Clear value proposition from user perspective}

**Current pain point:** {What problem does this solve?}

## Success Criteria

When this epic is complete:

- [ ] {Measurable criterion 1}
- [ ] {Measurable criterion 2}
- [ ] {Measurable criterion 3}

**Definition of Done:**
- All user stories completed
- Integration tests passing
- Documentation updated
- {Epic-specific criteria}

## Scope

### In Scope
- {Feature/capability that IS included}
- {Feature/capability that IS included}
- {Feature/capability that IS included}

### Out of Scope
- {Feature/capability that is NOT included}
- {Feature/capability deferred to different epic}

### Boundaries
{Clear statement of what this epic covers vs what other epics handle}

## Dependencies

**Depends on:**
- Epic {EPIC_ID}: {Title} - {Why this is needed first}
- {Link to epic file: ../epic-{identifier}-{nn}-{slug}.md}

**Enables:**
- Epic {EPIC_ID}: {Title} - {What becomes possible after this}

**No dependencies:** {If applicable}

## Estimated Stories

**Story count:** ~{number} user stories

**Complexity:** {Low/Medium/High}

**Estimated effort:** {Small/Medium/Large epic}

## Technical Considerations

{High-level technical notes, constraints, or architecture decisions relevant to this epic}

## Risks & Assumptions

**Risks:**
- {Risk 1 and mitigation}
- {Risk 2 and mitigation}

**Assumptions:**
- {Assumption 1}
- {Assumption 2}

## Related Epics

- Epic {EPIC_ID}: {Title} - {Relationship}
- Link: [epic-{identifier}-{nn}-{slug}.md](epic-{identifier}-{nn}-{slug}.md)

## Source Reference

**Original PRD:** [PRD-{identifier}.md](../PRD-{identifier}.md)

**Relevant sections:** {Which parts of PRD informed this epic}

## Traceability

**Full chain:**
```
PRD-{identifier}.md
└─ epic-{identifier}-{nn}-{slug}.md (this file)
   └─ stories/epic-{identifier}-{nn}/ (stories created here)
      └─ specs/epic-{identifier}-{nn}/ (specs created here)
```

---

**Next step:** Run `/sl-story-creator .workflow/epics/epic-{EPIC_ID}-{slug}.md`
