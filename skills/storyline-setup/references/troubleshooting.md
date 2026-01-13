# Troubleshooting Reference

## Common Issues and Solutions

### Installation Issues

#### Problem: Commands not found

**Symptoms:**
```
-bash: /sl-setup: No such file or directory
```

**Cause:** Storyline not installed or commands not symlinked.

**Solution:**
```bash
# Check if Storyline is installed
ls ~/.claude/skills/ | grep storyline

# If not found, install:
cd ~/.claude
git clone https://github.com/anthropics/storyline.git
cd storyline
./install.sh

# Or use remote installer:
bash <(curl -fsSL https://raw.githubusercontent.com/anthropics/storyline/main/remote-install.sh)
```

#### Problem: Skills installed but commands don't work

**Symptoms:**
Skills exist in `~/.claude/skills/` but commands fail.

**Cause:** Commands not symlinked to `~/.claude/commands/`.

**Solution:**
```bash
cd ~/.claude/skills/storyline
./install.sh
```

This recreates the command symlinks.

#### Problem: Permission denied

**Symptoms:**
```
Permission denied: cannot create directory .workflow
```

**Cause:** No write permission in current directory.

**Solution:**
```bash
# Check current directory permissions
ls -la .

# Grant write permission
chmod +w .

# Or run from a directory you own
cd ~/projects/my-project
/sl-setup init
```

### Project Structure Issues

#### Problem: .workflow/ exists but is empty

**Symptoms:**
```
/sl-setup status
→ No PRDs found yet.
```

**Cause:** Initialized but no work created yet.

**Solution:**
This is normal! Create your first epic:
```bash
/sl-epic-creator
```

#### Problem: Files in wrong locations

**Symptoms:**
- Stories not in epic subdirectories
- Specs at wrong level

**Cause:** Manually created files instead of using commands.

**Solution:**
Move files to correct structure:
```bash
# Move stories into epic subdirectories
mkdir -p .workflow/stories/epic-001
mv .workflow/stories/story-*.md .workflow/stories/epic-001/

# Move specs into epic subdirectories
mkdir -p .workflow/specs/epic-001
mv .workflow/specs/spec-*.md .workflow/specs/epic-001/
```

#### Problem: Can't find parent files

**Symptoms:**
```
Error: Cannot find parent epic at ../../epics/epic-001-auth.md
```

**Cause:** Relative path in frontmatter is incorrect.

**Solution:**
Verify file structure:
```bash
# From project root
ls .workflow/epics/epic-001-*.md

# Check relative path from story location
# From .workflow/stories/epic-001/story-01.md
# Parent should be at: ../../epics/epic-001-*.md
```

Fix frontmatter in story file:
```yaml
---
parent_epic: ../../epics/epic-001-auth.md  # Correct path
---
```

### Identifier Issues

#### Problem: Invalid identifier error

**Symptoms:**
```
Error: Invalid identifier "MCO 1234"
Identifiers can only contain: a-z, A-Z, 0-9, hyphens, underscores
```

**Cause:** Identifier contains spaces or special characters.

**Solution:**
Use valid format:
```
✅ MCO-1234
✅ mco_1234
✅ feature789
❌ MCO 1234 (space)
❌ MCO#1234 (special char)
❌ MCO.1234 (period)
```

#### Problem: Mixed identifiers in one epic

**Symptoms:**
Epic has identifier `mco-1234` but stories reference `MCO-1234`.

**Cause:** Case sensitivity or typo.

**Solution:**
Identifiers are case-sensitive. Be consistent:
```bash
# Check what identifier was used
grep -r "identifier:" .workflow/epics/

# Use exact case throughout
```

#### Problem: Forgot to add identifier, want to add later

**Symptoms:**
Created work without identifier, now want to track it.

**Cause:** Skipped identifier during creation.

**Solution:**
Rename files manually:
```bash
# Rename PRD
mv .workflow/PRD-001.md .workflow/PRD-mco-1234.md

# Rename epics
mv .workflow/epics/epic-001-auth.md .workflow/epics/epic-mco-1234-01-auth.md

# Rename story directories
mv .workflow/stories/epic-001 .workflow/stories/epic-mco-1234-01

# Rename spec directories
mv .workflow/specs/epic-001 .workflow/specs/epic-mco-1234-01

# Update frontmatter in all files to reflect new identifiers
```

**Note:** This is manual work. Better to use identifiers from the start if you'll need them.

### Workflow Issues

#### Problem: Don't know what to do next

**Symptoms:**
Confused about where you are in the workflow.

**Solution:**
```bash
/sl-setup status
```

This shows:
- What you've created
- What's incomplete
- Suggested next command

#### Problem: Created too many epics

**Symptoms:**
Have 10 epics, overwhelmed, don't know where to start.

**Cause:** Over-planned before validating.

**Solution:**
**Focus on one epic:**
```bash
# List epics
ls .workflow/epics/

# Pick highest priority epic
/sl-story-creator .workflow/epics/epic-001-core.md

# Implement one story to validate approach
/sl-spec-story .workflow/stories/epic-001/story-01.md
/sl-develop .workflow/specs/epic-001/spec-01.md
```

**Don't create all specs first.** Implement one, learn, iterate.

#### Problem: Story too vague to create spec

**Symptoms:**
Story doesn't have enough detail for technical spec.

**Cause:** Story written too high-level.

**Solution:**
1. **Enhance the story:** Edit story file to add more acceptance criteria.
2. **Ask questions:** Use AskUserQuestion during spec creation to clarify.
3. **Split the story:** Maybe it's actually multiple stories.

#### Problem: Spec is too large

**Symptoms:**
Spec is 10 pages, too complex to implement.

**Cause:** Story was too complex, should have been split.

**Solution:**
Split the spec into multiple parts:
```bash
# Create spec-story03-01.md (first part)
/sl-spec-story .workflow/stories/epic-001/story-03.md
# → Choose: "Complex story - multiple specs"

# Create spec-story03-02.md (second part)
/sl-spec-story .workflow/stories/epic-001/story-03.md
# → Choose: "Complex story - multiple specs"
```

### Git and Version Control

#### Problem: Should I commit .workflow/?

**Answer:** **YES!**

`.workflow/` contains your project documentation. Commit it.

```bash
git add .workflow/
git commit -m "Add epic and stories for auth feature"
```

#### Problem: Should I commit .planning/?

**Answer:** **Usually NO.**

`.planning/` contains temporary execution plans. Add to `.gitignore`:

```bash
echo ".workflow/.planning/" >> .gitignore
```

The specs are the source of truth, not the plans.

#### Problem: Merge conflicts in .workflow/

**Symptoms:**
Two developers created epics/stories, git conflicts.

**Solution:**
This is rare but possible. Resolve like any markdown conflict:

1. **Check what changed:**
   ```bash
   git diff .workflow/
   ```

2. **Keep both if different epics:**
   - Developer A: epic-001-auth.md
   - Developer B: epic-002-tasks.md
   - Keep both!

3. **Merge if same epic:**
   - Manually merge the content
   - Ensure numbering is sequential

4. **Re-run status:**
   ```bash
   /sl-setup status
   ```

### Dependency Issues

#### Problem: create-plans not found

**Symptoms:**
```
Error: create-plans skill required for /sl-develop
```

**Cause:** Dependency not installed.

**Solution:**
```bash
# Install create-plans skill
# (instructions depend on where create-plans is hosted)
# Usually:
cd ~/.claude/skills
git clone https://github.com/anthropics/create-plans.git
```

Check with:
```bash
/sl-setup check
```

#### Problem: Storyline commands conflict with other skills

**Symptoms:**
Two skills try to provide same command.

**Solution:**
Storyline uses `sl-` prefix to avoid conflicts:
- `/sl-epic-creator` (not `/epic-creator`)
- `/sl-story-creator` (not `/story-creator`)

If conflict still occurs, check:
```bash
ls -la ~/.claude/commands/ | grep sl-
```

Remove duplicate symlinks.

### Miscellaneous

#### Problem: Storyline is slow

**Cause:** Large project with many files.

**Solution:**
1. **Use specific paths:** Don't scan entire .workflow/ repeatedly.
2. **Archive old work:** Move completed initiatives to `.workflow/archive/`.
3. **Check file count:**
   ```bash
   find .workflow/ -type f | wc -l
   ```

If thousands of files, consider archiving.

#### Problem: Lost track of what identifier means

**Symptoms:**
Have `PRD-mco-1234.md` but forgot what MCO-1234 is.

**Solution:**
Open the PRD file:
```bash
cat .workflow/PRD-mco-1234.md
```

PRD should explain the context. If not, add a note:
```markdown
---
prd_id: mco-1234
title: Mobile Checkout Optimization
jira_ticket: https://jira.company.com/browse/MCO-1234
---
```

#### Problem: Want to delete an epic

**Symptoms:**
Created epic by mistake, want to remove it.

**Solution:**
**Before deleting, check if stories/specs exist:**
```bash
ls .workflow/stories/epic-001/
ls .workflow/specs/epic-001/
```

**If they exist, delete those first:**
```bash
rm -r .workflow/stories/epic-001/
rm -r .workflow/specs/epic-001/
rm .workflow/epics/epic-001-*.md
```

**Then verify:**
```bash
/sl-setup status
```

#### Problem: Inherited v1 project, want to upgrade to v2

**Symptoms:**
Old flat structure, want epic subdirectories.

**Solution:**
**v2 is backward compatible!** Old structure still works.

To upgrade gradually:
1. **Keep old files as-is** (they work fine)
2. **Use v2 structure for new work** (epic subdirectories)
3. **Migrate old files if desired:**
   ```bash
   mkdir -p .workflow/stories/epic-001
   mv .workflow/stories/story-001-*.md .workflow/stories/epic-001/

   mkdir -p .workflow/specs/epic-001
   mv .workflow/specs/spec-001-*.md .workflow/specs/epic-001/
   ```

## Getting Help

**Verify installation:**
```bash
/sl-setup check
```

**Check project state:**
```bash
/sl-setup status
```

**Read the guide:**
```bash
/sl-setup guide
```

**Check directory structure:**
```bash
tree .workflow/
# or
ls -R .workflow/
```

**View file contents:**
```bash
cat .workflow/PRD-*.md
cat .workflow/epics/epic-*.md
```

**Search for identifier:**
```bash
grep -r "mco-1234" .workflow/
```

## Still Stuck?

Open an issue:
https://github.com/anthropics/storyline/issues

Include:
1. Output of `/sl-setup check`
2. Output of `/sl-setup status`
3. What you're trying to do
4. What error you're seeing
