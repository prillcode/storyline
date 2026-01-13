# Initialize Project Workflow

**Purpose:** Create `.workflow/` directory structure only, without interactive prompts.

**Context:** User ran `/sl-setup init`

## Steps

### 1. Check if Already Initialized

Use Bash tool:
```bash
[ -d ".workflow" ] && echo "EXISTS" || echo "NOT_FOUND"
```

**If EXISTS:**
Display:
```
.workflow/ directory already exists!

To see your project status, run: /sl-setup status
```
Stop here.

**If NOT_FOUND:**
Continue to initialization...

### 2. Create Directory Structure

Use Bash tool to create all directories:
```bash
mkdir -p .workflow/epics .workflow/stories .workflow/specs .workflow/.planning
```

### 3. Create README.md

Load templates/workflow-readme.md and write to `.workflow/README.md`.

Use Write tool:
- file_path: `.workflow/README.md`
- content: [Content from template]

### 4. Verify Creation

Use Bash tool to confirm:
```bash
ls -la .workflow/
```

### 5. Display Success Message

Display:
```
✅ Storyline project initialized!

Created directory structure:
  .workflow/
  ├── README.md       # Documentation and quick reference
  ├── epics/          # Epic-level themes from PRDs
  ├── stories/        # User stories from epics
  ├── specs/          # Technical specifications
  └── .planning/      # Execution plans (auto-generated)

Next steps:
1. Create your first epic:
   /sl-epic-creator [path-to-prd]

   Or use guided mode (no PRD needed):
   /sl-epic-creator

2. Learn the full workflow:
   /sl-setup guide

3. Check project status anytime:
   /sl-setup status
```

## Implementation Notes

**Silent creation:** No interactive prompts, just create and confirm.

**Idempotent:** If .workflow/ exists, don't fail - just inform user.

**Minimal output:** Users who run `init` want fast setup.

**Clear next steps:** Always tell user what to do after initialization.

## Error Handling

**Permission denied:**
```
❌ Unable to create .workflow/ directory.

This may be a permissions issue. Try:
  sudo chmod +w .

Or run from a directory where you have write access.
```

**Partial creation failure:** Some directories created, others failed
```
⚠️  Partial initialization. Some directories could not be created.

Please check permissions and try again, or create manually:
  mkdir -p .workflow/epics .workflow/stories .workflow/specs .workflow/.planning
```
