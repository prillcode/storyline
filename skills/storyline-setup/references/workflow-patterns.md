# Workflow Patterns Reference

## Overview

This document shows common usage patterns and real-world scenarios for using Storyline.

## Pattern 1: Startup MVP

**Scenario:** Building first version of a new product.

**Characteristics:**
- Single PRD
- 2-4 epics
- Use identifier (for investor/board tracking)

**Workflow:**

```bash
# 1. Initialize project
/sl-setup init

# 2. Create epics (guided mode)
/sl-epic-creator
# → Provide identifier: MVP-2024
# → Answer guided questions about product vision
# → Output: PRD-mvp-2024.md + 3 epic files

# 3. Start with highest priority epic
/sl-story-creator .workflow/epics/epic-mvp-2024-01-core-features.md
# → Output: 5 stories in .workflow/stories/epic-mvp-2024-01/

# 4. Create specs for first sprint
/sl-spec-story .workflow/stories/epic-mvp-2024-01/story-01.md
/sl-spec-story .workflow/stories/epic-mvp-2024-01/story-02.md
# → Output: specs in .workflow/specs/epic-mvp-2024-01/

# 5. Implement
/sl-develop .workflow/specs/epic-mvp-2024-01/spec-01.md
/sl-develop .workflow/specs/epic-mvp-2024-01/spec-02.md

# 6. Check progress
/sl-setup status
```

**Resulting structure:**
```
.workflow/
├── PRD-mvp-2024.md
├── epics/
│   ├── epic-mvp-2024-01-core-features.md
│   ├── epic-mvp-2024-02-user-management.md
│   └── epic-mvp-2024-03-integrations.md
├── stories/epic-mvp-2024-01/
│   ├── story-01.md through story-05.md
├── specs/epic-mvp-2024-01/
│   ├── spec-01.md
│   └── spec-02.md
└── (continue with other epics...)
```

## Pattern 2: Adding Feature to Existing Product

**Scenario:** Product exists, adding new major feature.

**Characteristics:**
- Multiple PRDs over time
- Each feature gets own identifier
- Existing codebase

**Workflow:**

```bash
# 1. Check current state
/sl-setup status
# → Shows existing PRD-mvp-2024.md work

# 2. Create new feature (separate PRD)
/sl-epic-creator
# → Provide identifier: FEATURE-789
# → Input: Describe new feature requirements
# → Output: PRD-feature-789.md + epic files

# 3. Continue with stories/specs/implementation
/sl-story-creator .workflow/epics/epic-feature-789-01-export.md
/sl-spec-story .workflow/stories/epic-feature-789-01/story-01.md
/sl-develop .workflow/specs/epic-feature-789-01/spec-01.md
```

**Resulting structure:**
```
.workflow/
├── PRD-mvp-2024.md              # Original work
├── PRD-feature-789.md           # NEW feature
├── epics/
│   ├── epic-mvp-2024-01-*.md    # Original epics
│   ├── epic-mvp-2024-02-*.md
│   └── epic-feature-789-01-export.md    # NEW epic
├── stories/
│   ├── epic-mvp-2024-01/        # Original stories
│   ├── epic-mvp-2024-02/
│   └── epic-feature-789-01/     # NEW stories
└── specs/
    ├── epic-mvp-2024-01/        # Original specs
    ├── epic-mvp-2024-02/
    └── epic-feature-789-01/     # NEW specs
```

## Pattern 3: JIRA Integration (Enterprise)

**Scenario:** Using JIRA for tracking, want to connect Storyline work to tickets.

**Characteristics:**
- Identifier = JIRA ticket ID
- Multiple concurrent initiatives
- Traceability to external system

**Workflow:**

```bash
# For JIRA ticket MCO-1234 (Mobile Checkout)
/sl-epic-creator
# → Identifier: MCO-1234
# → Creates: PRD-mco-1234.md

/sl-story-creator .workflow/epics/epic-mco-1234-01-payment.md
# → Stories in: .workflow/stories/epic-mco-1234-01/

# For JIRA ticket DASH-567 (New Dashboard)
/sl-epic-creator
# → Identifier: DASH-567
# → Creates: PRD-dash-567.md

/sl-story-creator .workflow/epics/epic-dash-567-01-widgets.md
# → Stories in: .workflow/stories/epic-dash-567-01/
```

**Benefits:**
- Easy to see all work for a JIRA ticket
- Grep by identifier: `grep -r "MCO-1234" .workflow/`
- Git commits can reference ticket: "MCO-1234: Implemented payment flow"

## Pattern 4: No Identifier (Simple Projects)

**Scenario:** Personal project, no external tracking needed.

**Characteristics:**
- Single developer
- No JIRA/Linear/etc.
- Simple numeric IDs

**Workflow:**

```bash
/sl-setup init

/sl-epic-creator
# → Identifier: [press Enter to skip]
# → Creates: PRD-001.md, epic-001-*.md

/sl-story-creator .workflow/epics/epic-001-*.md
# → Creates: .workflow/stories/epic-001/

/sl-spec-story .workflow/stories/epic-001/story-01.md
# → Creates: .workflow/specs/epic-001/spec-01.md
```

**Resulting structure:**
```
.workflow/
├── PRD-001.md
├── epics/
│   ├── epic-001-auth.md
│   └── epic-002-features.md
├── stories/
│   ├── epic-001/
│   └── epic-002/
└── specs/
    ├── epic-001/
    └── epic-002/
```

## Pattern 5: Complex Story Splitting

**Scenario:** User story is too large to implement in one spec.

**Characteristics:**
- One story → multiple specs
- Sequential implementation
- Clear split points

**Workflow:**

```bash
# Story 3 is "Implement advanced search"
# Too complex for one spec, split into:
# - Part 1: Basic text search
# - Part 2: Filters and facets
# - Part 3: Search analytics

/sl-spec-story .workflow/stories/epic-mco-1234-01/story-03.md
# → Choose: "Complex story - will need multiple specs"
# → Name this part: "basic-text-search"
# → Output: spec-story03-01-basic-text-search.md

/sl-spec-story .workflow/stories/epic-mco-1234-01/story-03.md
# → Choose: "Complex story - will need multiple specs"
# → Name this part: "filters-and-facets"
# → Output: spec-story03-02-filters-and-facets.md

/sl-spec-story .workflow/stories/epic-mco-1234-01/story-03.md
# → Choose: "Complex story - will need multiple specs"
# → Name this part: "search-analytics"
# → Output: spec-story03-03-search-analytics.md
```

**Resulting structure:**
```
.workflow/specs/epic-mco-1234-01/
├── spec-01.md                            # Story 1 (simple)
├── spec-02.md                            # Story 2 (simple)
├── spec-story03-01-basic-text-search.md  # Story 3, part 1
├── spec-story03-02-filters-and-facets.md # Story 3, part 2
└── spec-story03-03-search-analytics.md   # Story 3, part 3
```

## Pattern 6: Combining Simple Stories

**Scenario:** Multiple small stories that should be implemented together.

**Characteristics:**
- Stories are trivial individually
- Related functionality
- More efficient as one spec

**Workflow:**

```bash
# Stories 4, 5, 6 are all small UI tweaks
# Combine into one spec

/sl-spec-story .workflow/stories/epic-mco-1234-01/story-04.md
# → Choose: "Combine with other stories"
# → Which stories? story-05.md, story-06.md
# → Output: spec-stories-04-05-06-combined.md
```

**Resulting structure:**
```
.workflow/specs/epic-mco-1234-01/
├── spec-01.md                           # Story 1
├── spec-02.md                           # Story 2
├── spec-03.md                           # Story 3
└── spec-stories-04-05-06-combined.md    # Stories 4+5+6 together
```

## Pattern 7: Mid-Project Status Check

**Scenario:** Been working for a while, need to see what's done and what's next.

**Workflow:**

```bash
/sl-setup status
```

**Example output:**
```
Storyline Project Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Initiative      | Epics | Stories | Specs | Status          |
|-----------------|-------|---------|-------|-----------------|
| PRD-mco-1234.md | 3     | 12      | 8     | In progress     |
| PRD-dash-567.md | 2     | 6       | 6     | Ready to develop|

Summary:
• 2 PRDs/initiatives
• 5 epics total
• 18 stories total
• 14 specs total

📋 Next suggested actions:

Continue epic-mco-1234-01:
  /sl-spec-story .workflow/stories/epic-mco-1234-01/story-05.md

Continue epic-mco-1234-02:
  /sl-spec-story .workflow/stories/epic-mco-1234-02/story-03.md

Implement ready specs from DASH-567:
  /sl-develop .workflow/specs/epic-dash-567-01/spec-01.md
```

## Pattern 8: Starting with Existing PRD Document

**Scenario:** Already have a detailed PRD document, want to use Storyline.

**Workflow:**

```bash
/sl-setup init

# Point to existing PRD
/sl-epic-creator docs/product-requirements.md
# → Identifier: (optional, e.g., Q4-2024)
# → How many epics? [Claude analyzes and suggests]
# → Output: PRD-q4-2024.md (copy) + epic files

# Continue as normal
/sl-story-creator .workflow/epics/epic-q4-2024-01-*.md
```

**Benefits:**
- Leverage existing documentation
- PRD stays in .workflow/ for traceability
- Epics extracted automatically

## Pattern 9: Exploratory Development (No PRD Yet)

**Scenario:** Exploring an idea, not ready for formal PRD.

**Workflow:**

```bash
/sl-setup init

# Use guided mode
/sl-epic-creator
# → Skip identifier (just exploring)
# → Answer questions:
#   - Goal: "Explore adding real-time collaboration"
#   - Users: "Internal team"
#   - Features: ["Cursor tracking", "Live editing", "Presence"]
#   - Constraints: "Must work with existing editor"
#   - Success: "Multiple users can edit simultaneously"
# → Output: PRD-001.md + epic-001-*.md

# Create just a few stories to start
/sl-story-creator .workflow/epics/epic-001-*.md

# Implement one spec to validate approach
/sl-spec-story .workflow/stories/epic-001/story-01.md
/sl-develop .workflow/specs/epic-001/spec-01.md
```

**Use case:**
- Prototyping
- Proof of concept
- Exploring feasibility

## Pattern 10: Team Handoff

**Scenario:** One developer did epics/stories, another will implement specs.

**Workflow:**

**Developer A (planning):**
```bash
/sl-setup init
/sl-epic-creator
/sl-story-creator .workflow/epics/epic-proj-123-01-*.md
/sl-spec-story .workflow/stories/epic-proj-123-01/story-01.md
# ... create all specs

# Commit to git
git add .workflow/
git commit -m "PROJ-123: Created specs for phase 1"
git push
```

**Developer B (implementation):**
```bash
# Pull latest
git pull

# Check what needs doing
/sl-setup status

# Start implementing
/sl-develop .workflow/specs/epic-proj-123-01/spec-01.md
/sl-develop .workflow/specs/epic-proj-123-01/spec-02.md
```

**Benefits:**
- Clear handoff point (specs are ready)
- Traceability maintained
- Both devs see full chain

## Common Commands Reference

**Setup and status:**
```bash
/sl-setup init       # Initialize project
/sl-setup status     # Check current state
/sl-setup guide      # See full tutorial
/sl-setup check      # Verify installation
```

**Create artifacts:**
```bash
/sl-epic-creator                           # Guided mode
/sl-epic-creator docs/prd.md              # From existing PRD
/sl-story-creator .workflow/epics/epic-*.md
/sl-spec-story .workflow/stories/epic-*/story-*.md
/sl-develop .workflow/specs/epic-*/spec-*.md
```

**Navigation:**
```bash
ls .workflow/epics/              # See all epics
ls .workflow/stories/            # See all story directories
ls .workflow/specs/              # See all spec directories
cat .workflow/PRD-*.md           # Read a PRD
```

## Tips

**Check status frequently:** `/sl-setup status` shows what's done and what's next.

**Use identifiers for tracking:** Makes it easy to find all work for a ticket.

**Don't over-plan:** Start with one epic, get to code, iterate.

**Combine trivial stories:** Don't create a spec for every tiny story.

**Split complex stories:** Don't try to implement huge stories in one go.

**Commit .workflow/:** Your specs ARE documentation. Don't lose them.

**Review before implementing:** Read the spec carefully before `/sl-develop`.
