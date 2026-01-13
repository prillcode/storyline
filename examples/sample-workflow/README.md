# Sample Workflow: Task Manager (v2.0)

This directory contains a complete example of the Storyline v2.0 workflow, demonstrating how to go from PRD to working code with identifiers and epic-based organization.

## Files in This Example

### 1. PRD-demo-auth.md
The original product requirements document with identifier `demo-auth`.

### 2. epics/epic-demo-auth-01-authentication.md
An epic generated from the PRD using `/sl-epic-creator PRD-demo-auth.md`

Shows how PRD features are broken into epic-level themes with identifier propagation.

### 3. stories/epic-demo-auth-01/story-01.md
A user story generated from the epic using `/sl-story-creator epics/epic-demo-auth-01-authentication.md`

**New in v2.0:** Stories organized in epic-specific subdirectories.

Demonstrates INVEST criteria and acceptance criteria format.

### 4. specs/epic-demo-auth-01/spec-01.md
A technical specification generated from the story using `/sl-spec-story stories/epic-demo-auth-01/story-01.md`

**New in v2.0:** Specs organized by epic with flexible strategies (simple/complex/combined).

Shows detailed implementation plan ready for execution.

### 5. Next Step: Implementation
Run `/sl-develop specs/epic-demo-auth-01/spec-01.md` to:
- Convert spec to PLAN.md
- Execute implementation using create-plans
- Generate working code
- Create SUMMARY.md with results

## The Full Pipeline (v2.0)

```
PRD-demo-auth.md
  ↓ /sl-epic-creator
epics/epic-demo-auth-01-authentication.md
  ↓ /sl-story-creator
stories/epic-demo-auth-01/story-01.md
  ↓ /sl-spec-story
specs/epic-demo-auth-01/spec-01.md
  ↓ /sl-develop
.planning/demo-auth-01-spec-01/PLAN.md → Code → SUMMARY.md
```

## Traceability

Every artifact links back to its source:
- Epic → PRD
- Story → Epic
- Spec → Story (+ Epic)
- Plan → Spec (+ Story + Epic)
- Summary → All of the above

You can trace any line of code back to the original PRD requirement.

## Try It Yourself

1. Read through the files in order (PRD → Epic → Story → Spec)
2. Notice how detail increases at each stage
3. See how acceptance criteria flow through the pipeline
4. Observe how technical decisions are made at the spec level
5. Understand how specs become executable plans

## What's Missing (Intentionally)

This example stops at the spec level. To see actual implementation:
1. Install Storyline: `./install.sh`
2. Create a new project
3. Copy this PRD.md
4. Run through the full pipeline
5. Observe code generation and git commits

## Learning Points

**Epic Creation:**
- PRD features → Epics by business capability
- Right-sized: 3-4 stories per epic
- Clear dependencies and boundaries

**Story Creation:**
- Epic → Multiple user stories
- INVEST criteria applied
- Acceptance criteria in Given/When/Then format

**Spec Creation:**
- Story → Detailed technical design
- All files identified
- API contracts defined
- Testing requirements specified

**Implementation:**
- Spec → Executable plan(s)
- Atomic tasks (2-3 per plan)
- Automatic code generation
- Full verification and testing
