# Verify Installation Workflow

**Purpose:** Check that all Storyline components are properly installed.

**Context:** User ran `/sl-setup check`

## Steps

### 1. Check Storyline Skills

Use Bash tool to check if Storyline skills exist:
```bash
ls ~/.claude/skills/ | grep -E "^storyline-"
```

**Expected skills:**
- storyline-epic-creator
- storyline-story-creator
- storyline-spec-story
- storyline-develop
- storyline-setup

Count how many are found.

### 2. Check Storyline Commands

Use Bash tool:
```bash
ls ~/.claude/commands/ | grep -E "^sl-"
```

**Expected commands:**
- sl-epic-creator.md
- sl-story-creator.md
- sl-spec-story.md
- sl-develop.md
- sl-setup.md

Count how many are found.

### 3. Check Dependencies

Use Bash tool to check for required dependencies:
```bash
ls ~/.claude/skills/ | grep -E "^(create-plans|create-agent-skills)$"
```

**Expected dependencies:**
- create-plans (used by storyline-develop)
- create-agent-skills (optional, for skill development)

### 4. Get Version Information

Use Bash tool to read package.json if it exists:
```bash
if [ -f ~/.claude/skills/storyline-setup/../../package.json ]; then
  grep '"version"' ~/.claude/skills/storyline-setup/../../package.json | head -1
else
  echo "Version file not found"
fi
```

Or check for a VERSION file in the storyline installation directory.

### 5. Display Results

**Format the output as a checklist:**

```
Storyline Installation Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Skills:
  ✅ storyline-epic-creator
  ✅ storyline-story-creator
  ✅ storyline-spec-story
  ✅ storyline-develop
  ✅ storyline-setup

Commands:
  ✅ sl-epic-creator
  ✅ sl-story-creator
  ✅ sl-spec-story
  ✅ sl-develop
  ✅ sl-setup

Dependencies:
  ✅ create-plans
  ⚠️  create-agent-skills (optional)

Version: 2.0.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ All core components installed correctly!

To get started:
  /sl-setup init    # Initialize a new project
  /sl-setup guide   # Learn the workflow
```

### 6. Handle Missing Components

**If any core component is missing:**

```
Storyline Installation Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Skills:
  ✅ storyline-epic-creator
  ❌ storyline-story-creator [MISSING]
  ✅ storyline-spec-story
  ✅ storyline-develop
  ✅ storyline-setup

⚠️  Some components are missing!

To reinstall Storyline:
  cd ~/.claude
  git clone https://github.com/anthropics/storyline.git
  cd storyline
  ./install.sh

Or use the one-line remote installer:
  bash <(curl -fsSL https://raw.githubusercontent.com/anthropics/storyline/main/remote-install.sh)

For help, visit: https://github.com/anthropics/storyline
```

## Implementation Notes

**Use checkmarks:** ✅ for found, ❌ for missing, ⚠️ for warnings

**Group by category:** Skills, Commands, Dependencies

**Version is optional:** Don't fail if version can't be determined

**Clear remediation:** If anything missing, show exact command to fix

**Distinguish optional vs required:** create-agent-skills is optional

## Typical Checks

**All installed correctly:**
```
✅ All core components installed correctly!
```

**Missing skills:**
```
⚠️  Some components are missing! See above for details.
```

**Missing dependencies:**
```
⚠️  create-plans not found. This is required for /sl-develop.

Install from: https://github.com/anthropics/claude-code-guide
```

## Error Handling

**Cannot access ~/.claude directory:**
```
❌ Cannot access ~/.claude directory.

Storyline should be installed in: ~/.claude/skills/storyline-*

Please ensure Claude Code is properly set up.
```

**Permissions issue:**
```
⚠️  Permission denied when checking installation.

Try: chmod +r ~/.claude/skills/
```
