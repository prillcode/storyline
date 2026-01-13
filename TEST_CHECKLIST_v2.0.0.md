# Storyline v2.0.0 Test Checklist

**Purpose:** Manual testing checklist for all v2.0 features before release.

**Test Environment:** Create a temporary test directory for each test case to avoid polluting your main project.

---

## Pre-Test Setup

- [ ] Install Storyline v2.0.0 to `~/.claude/` directory
- [ ] Verify installation: Run `/sl-setup check` and confirm version shows 2.0.0
- [ ] Create test directory: `mkdir ~/storyline-v2-tests && cd ~/storyline-v2-tests`

---

## Test Case 1: Fresh Project with Identifier ✅

**Goal:** Verify complete workflow with identifier tracking

### Steps

1. **Setup**
   - [ ] Create new test directory: `mkdir test-case-1 && cd test-case-1`
   - [ ] Run `/sl-setup init`
   - [ ] Verify directories created:
     - [ ] `.workflow/` exists
     - [ ] `.workflow/epics/` exists
     - [ ] `.workflow/stories/` exists
     - [ ] `.workflow/specs/` exists
     - [ ] `.workflow/.planning/` exists
     - [ ] `.workflow/README.md` exists

2. **Guided PRD Creation**
   - [ ] Run `/sl-epic-creator` (no arguments)
   - [ ] Provide identifier when prompted: `TEST-123`
   - [ ] Answer guided questions:
     - Goal: "Build a task management system"
     - Users: "Project managers and team members"
     - Features: "Task creation, assignment, status tracking"
     - Constraints: "Must work offline-first"
     - Success: "Users can manage tasks without internet"
   - [ ] Verify PRD created: `ls .workflow/PRD-test-123.md`
   - [ ] Verify PRD content includes your answers
   - [ ] Verify epics created: `ls .workflow/epics/epic-test-123-*`

3. **Epic Verification**
   - [ ] Open first epic file
   - [ ] Verify frontmatter contains:
     - [ ] `epic_id: test-123-01`
     - [ ] `identifier: test-123`
     - [ ] `prd_source: ../PRD-test-123.md`
   - [ ] Verify epic content describes work appropriately

4. **Story Creation**
   - [ ] Run `/sl-story-creator .workflow/epics/epic-test-123-01-*.md`
   - [ ] Verify stories directory created: `ls .workflow/stories/epic-test-123-01/`
   - [ ] Verify stories exist: `ls .workflow/stories/epic-test-123-01/story-*.md`
   - [ ] Open first story file
   - [ ] Verify frontmatter contains:
     - [ ] `story_id: 01`
     - [ ] `epic_id: test-123-01`
     - [ ] `identifier: test-123`
     - [ ] `parent_epic: ../../epics/epic-test-123-01-*.md`

5. **Spec Creation (Simple Strategy)**
   - [ ] Run `/sl-spec-story .workflow/stories/epic-test-123-01/story-01.md`
   - [ ] When prompted, choose "Simple" strategy
   - [ ] Verify specs directory created: `ls .workflow/specs/epic-test-123-01/`
   - [ ] Verify spec exists: `ls .workflow/specs/epic-test-123-01/spec-01.md`
   - [ ] Open spec file
   - [ ] Verify frontmatter contains:
     - [ ] `spec_id: 01`
     - [ ] `story_ids: [01]`
     - [ ] `epic_id: test-123-01`
     - [ ] `identifier: test-123`
     - [ ] `parent_story: ../stories/epic-test-123-01/story-01.md`
     - [ ] `complexity: simple`

6. **Development** (Optional - can be time-consuming)
   - [ ] Run `/sl-develop .workflow/specs/epic-test-123-01/spec-01.md`
   - [ ] Verify planning directory created
   - [ ] Verify identifier included in context

7. **Traceability Check**
   - [ ] Manually verify you can navigate the chain:
     - [ ] From spec → story (via parent_story path)
     - [ ] From story → epic (via parent_epic path)
     - [ ] From epic → PRD (via prd_source path)

### Expected Results
✅ Complete chain from PRD → Epic → Story → Spec with identifiers propagated throughout

---

## Test Case 2: Fresh Project without Identifier ✅

**Goal:** Verify workflow works without identifiers (backward compatibility)

### Steps

1. **Setup**
   - [ ] Create new test directory: `mkdir ../test-case-2 && cd ../test-case-2`
   - [ ] Run `/sl-setup init`

2. **Guided PRD Creation (No Identifier)**
   - [ ] Run `/sl-epic-creator`
   - [ ] When prompted for identifier, press **Enter** to skip
   - [ ] Answer guided questions (simple answers)
   - [ ] Verify PRD created: `ls .workflow/PRD-001.md`
   - [ ] Verify epics created: `ls .workflow/epics/epic-001-*.md`

3. **Epic Verification**
   - [ ] Open first epic
   - [ ] Verify frontmatter:
     - [ ] `epic_id: 001-01` (or similar, no custom identifier)
     - [ ] No `identifier` field (or empty)

4. **Story Creation**
   - [ ] Run `/sl-story-creator .workflow/epics/epic-001-01-*.md`
   - [ ] Verify directory: `ls .workflow/stories/epic-001-01/`
   - [ ] Verify stories created
   - [ ] Check frontmatter has numeric IDs only

5. **Spec Creation**
   - [ ] Run `/sl-spec-story .workflow/stories/epic-001-01/story-01.md`
   - [ ] Choose "Simple" strategy
   - [ ] Verify spec created: `ls .workflow/specs/epic-001-01/spec-01.md`
   - [ ] Check frontmatter uses numeric IDs

### Expected Results
✅ Complete workflow functions without identifiers, using numeric fallbacks (001, 002, etc.)

---

## Test Case 3: Multiple PRDs in One Project ✅

**Goal:** Verify multiple initiatives can coexist with different identifiers

### Steps

1. **Setup**
   - [ ] Create new test directory: `mkdir ../test-case-3 && cd ../test-case-3`
   - [ ] Run `/sl-setup init`

2. **First Initiative (PROJ-A)**
   - [ ] Run `/sl-epic-creator`
   - [ ] Provide identifier: `PROJ-A`
   - [ ] Answer questions (simple answers)
   - [ ] Verify: `ls .workflow/PRD-proj-a.md`
   - [ ] Verify: `ls .workflow/epics/epic-proj-a-*`

3. **Create Stories for PROJ-A**
   - [ ] Run `/sl-story-creator` on PROJ-A epic
   - [ ] Verify: `ls .workflow/stories/epic-proj-a-01/`

4. **Create Spec for PROJ-A**
   - [ ] Run `/sl-spec-story` on PROJ-A story
   - [ ] Verify: `ls .workflow/specs/epic-proj-a-01/`

5. **Second Initiative (PROJ-B)**
   - [ ] Run `/sl-epic-creator` again
   - [ ] Provide identifier: `PROJ-B`
   - [ ] Answer questions (different from PROJ-A)
   - [ ] Verify: `ls .workflow/PRD-proj-b.md`
   - [ ] Verify: `ls .workflow/epics/epic-proj-b-*`

6. **Create Stories for PROJ-B**
   - [ ] Run `/sl-story-creator` on PROJ-B epic
   - [ ] Verify: `ls .workflow/stories/epic-proj-b-01/`

7. **Create Spec for PROJ-B**
   - [ ] Run `/sl-spec-story` on PROJ-B story
   - [ ] Verify: `ls .workflow/specs/epic-proj-b-01/`

8. **Project Status**
   - [ ] Run `/sl-setup status`
   - [ ] Verify output shows:
     - [ ] Both PRDs listed (PRD-proj-a.md and PRD-proj-b.md)
     - [ ] Separate epic groups for each identifier
     - [ ] Story and spec counts for each initiative
     - [ ] No file conflicts or collisions

### Expected Results
✅ Two independent initiatives coexist peacefully with separate identifiers and directory structures

---

## Test Case 4: Complex Spec Strategies ✅

**Goal:** Verify all three spec strategies work correctly

### Steps

1. **Setup**
   - [ ] Create new test directory: `mkdir ../test-case-4 && cd ../test-case-4`
   - [ ] Run `/sl-setup init`
   - [ ] Run `/sl-epic-creator` with identifier `SPEC-TEST`
   - [ ] Create stories: Get at least 4 stories created in one epic

2. **Simple Strategy (1 story → 1 spec)**
   - [ ] Run `/sl-spec-story .workflow/stories/epic-spec-test-01/story-01.md`
   - [ ] Choose **"Simple"** strategy
   - [ ] Verify created: `ls .workflow/specs/epic-spec-test-01/spec-01.md`
   - [ ] Verify frontmatter:
     - [ ] `spec_id: 01`
     - [ ] `story_ids: [01]`
     - [ ] `complexity: simple`

3. **Complex Strategy (1 story → multiple specs)**
   - [ ] Run `/sl-spec-story .workflow/stories/epic-spec-test-01/story-02.md`
   - [ ] Choose **"Complex"** strategy
   - [ ] When prompted, specify you need 2 specs for this story
   - [ ] Verify created:
     - [ ] `ls .workflow/specs/epic-spec-test-01/spec-story02-01.md`
     - [ ] `ls .workflow/specs/epic-spec-test-01/spec-story02-02.md`
   - [ ] Verify frontmatter in both specs:
     - [ ] Both reference `story_ids: [02]`
     - [ ] `complexity: split` or `complexity: complex`

4. **Combined Strategy (multiple stories → 1 spec)**
   - [ ] Run `/sl-spec-story .workflow/stories/epic-spec-test-01/story-03.md`
   - [ ] Choose **"Combined"** strategy
   - [ ] When prompted, specify combining with story-04
   - [ ] Verify created: `ls .workflow/specs/epic-spec-test-01/spec-stories-03-04-combined.md`
   - [ ] Verify frontmatter:
     - [ ] `story_ids: [03, 04]` (array of both stories)
     - [ ] `complexity: combined`
   - [ ] Verify spec content includes context from both stories

5. **Directory Check**
   - [ ] Run `ls .workflow/specs/epic-spec-test-01/`
   - [ ] Verify all specs are in the correct epic subdirectory
   - [ ] Verify naming conventions are correct

### Expected Results
✅ All three spec strategies work and create appropriately named files with correct frontmatter

---

## Test Case 5: Backward Compatibility ✅

**Goal:** Verify old v1.x projects still work with v2.0

### Steps

1. **Simulate v1.x Structure**
   - [ ] Create new test directory: `mkdir ../test-case-5 && cd ../test-case-5`
   - [ ] Create old v1.x structure manually:
     ```bash
     mkdir -p .workflow/epics .workflow/stories .workflow/specs
     ```
   - [ ] Create a v1.x style epic (no identifier):
     ```bash
     cat > .workflow/epics/epic-001-authentication.md <<EOF
     ---
     epic_id: 001
     title: Authentication
     ---
     # Epic: Authentication
     User authentication system
     EOF
     ```

2. **Test Story Creation on Old Epic**
   - [ ] Run `/sl-story-creator .workflow/epics/epic-001-authentication.md`
   - [ ] Verify stories created (should handle missing identifier gracefully)
   - [ ] Check that stories work even without identifier in epic

3. **Test Spec Creation on Old Story**
   - [ ] Run `/sl-spec-story` on created story
   - [ ] Verify spec created successfully
   - [ ] Check that spec works without identifier

4. **Test Mixed Old/New**
   - [ ] Run `/sl-epic-creator` with identifier `NEW-FEAT`
   - [ ] Verify new epic coexists with old epic-001
   - [ ] Verify both show up in `/sl-setup status`

### Expected Results
✅ Old v1.x structures work correctly, and new v2.0 features can be added alongside old work

---

## Integration Tests

### Full Pipeline Test

- [ ] Create new test directory: `mkdir ../integration-test && cd ../integration-test`
- [ ] Run complete pipeline from start to finish:
  1. [ ] `/sl-setup init`
  2. [ ] `/sl-epic-creator` (guided, with identifier)
  3. [ ] `/sl-story-creator` on epic
  4. [ ] `/sl-spec-story` on story
  5. [ ] `/sl-develop` on spec (optional, time-consuming)
- [ ] Verify no errors at any stage
- [ ] Verify all files link correctly (check relative paths)

### Status Command Test

- [ ] In a test project with multiple PRDs, epics, stories, specs
- [ ] Run `/sl-setup status`
- [ ] Verify output shows:
  - [ ] Correct count of PRDs
  - [ ] Correct count of epics per identifier
  - [ ] Correct count of stories per epic
  - [ ] Correct count of specs per epic
  - [ ] Suggestions for next steps (if any incomplete chains)

### Check Command Test

- [ ] Run `/sl-setup check` from any directory
- [ ] Verify output shows:
  - [ ] All Storyline skills found (5 skills)
  - [ ] All Storyline commands found (5 commands)
  - [ ] Dependencies found (create-plans, etc.)
  - [ ] Version: 2.0.0

### Guide Command Test

- [ ] Run `/sl-setup guide`
- [ ] Verify comprehensive guide is displayed
- [ ] Check guide includes:
  - [ ] Workflow diagram
  - [ ] Command examples
  - [ ] Identifier explanation
  - [ ] Directory structure
  - [ ] Tips and best practices

---

## Edge Cases & Error Handling

### Invalid Identifier

- [ ] Run `/sl-epic-creator` with guided mode
- [ ] Try providing invalid identifier (e.g., `TEST 123` with space)
- [ ] Verify validation error and re-prompt

### Empty Identifier

- [ ] Provide empty/blank identifier
- [ ] Verify falls back to numeric (001, 002, etc.)

### Missing Dependencies

- [ ] Temporarily rename create-plans skill
- [ ] Run `/sl-setup check`
- [ ] Verify warning about missing dependency
- [ ] Restore create-plans skill

### Non-existent Epic File

- [ ] Try running `/sl-story-creator` on non-existent epic
- [ ] Verify appropriate error message

---

## Performance & Sanity Checks

### File Permissions

- [ ] Verify all created files have appropriate permissions (readable/writable)
- [ ] Verify no permission errors during any operation

### Large Projects

- [ ] Create project with 3+ PRDs, 5+ epics each
- [ ] Run `/sl-setup status`
- [ ] Verify status command performs reasonably (< 5 seconds)

### Path Handling

- [ ] Verify relative paths work correctly in all traceability links
- [ ] Test clicking through paths (if using IDE that supports it)
- [ ] Verify no broken links in any generated file

---

## Documentation Checks

- [ ] Read through [README.md](README.md)
  - [ ] v2.0 features are clearly explained
  - [ ] Examples use new v2.0 patterns
  - [ ] Installation instructions are correct
  - [ ] Version number is 2.0.0
- [ ] Read through [RELEASE_NOTES_v2.0.0.md](RELEASE_NOTES_v2.0.0.md)
  - [ ] All major features are documented
  - [ ] Migration guide is clear
  - [ ] Breaking changes section is accurate (none)
- [ ] Check [install.sh](install.sh)
  - [ ] Welcome message mentions v2.0
  - [ ] Lists all new commands
- [ ] Check [uninstall.sh](uninstall.sh)
  - [ ] Includes storyline-setup in uninstall

---

## Final Checklist

### Before Publishing

- [ ] All 5 test cases passed
- [ ] Integration tests passed
- [ ] Edge cases handled appropriately
- [ ] Documentation is accurate and complete
- [ ] Version number is 2.0.0 everywhere
- [ ] Git tag v2.0.0 exists
- [ ] Commit message is clear and detailed
- [ ] No sensitive information in files

### Ready to Publish

- [ ] Push commits to GitHub: `git push origin main`
- [ ] Push tags to GitHub: `git push origin v2.0.0`
- [ ] Create GitHub release from tag
- [ ] Copy contents of RELEASE_NOTES_v2.0.0.md to release description
- [ ] Update homepage/website with v2.0 announcement (if applicable)
- [ ] Announce in discussions/social media

---

## Test Results Summary

**Test Date:** _________________

**Tester:** _________________

**Environment:**
- OS: _________________
- Claude Code Version: _________________
- Storyline Version: 2.0.0

**Results:**

| Test Case | Status | Notes |
|-----------|--------|-------|
| Test Case 1: Fresh with Identifier | ⬜ Pass / ⬜ Fail | |
| Test Case 2: Fresh without Identifier | ⬜ Pass / ⬜ Fail | |
| Test Case 3: Multiple PRDs | ⬜ Pass / ⬜ Fail | |
| Test Case 4: Spec Strategies | ⬜ Pass / ⬜ Fail | |
| Test Case 5: Backward Compatibility | ⬜ Pass / ⬜ Fail | |
| Integration Tests | ⬜ Pass / ⬜ Fail | |
| Edge Cases | ⬜ Pass / ⬜ Fail | |

**Issues Found:**

1. _________________
2. _________________
3. _________________

**Sign-off:** _________________

---

**Notes:**
- Each test case should be run in isolation in a fresh test directory
- Use descriptive commit messages if you fix any issues found during testing
- Document any edge cases or unexpected behavior
- Take screenshots of any UI elements (if applicable)
