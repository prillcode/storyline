# Storyline

**The sl-commands for story-led development**

Transform PRDs and technical specs into working code through a structured pipeline: **Epic → Story → Spec → Implementation**

---

## What is Storyline?

Storyline is a CLI toolkit for Claude Code that implements a complete story-driven development workflow. It bridges the gap between product requirements and working code through clear, traceable steps.

**The Pipeline:**

```
PRD/Tech Spec → Epics → User Stories → Technical Specs → Implementation
     ↓            ↓         ↓              ↓                ↓
[epic-creator] [story] [spec-story]  [develop] → [create-plans] → Code
                                                      ↓
                                              Plan → Execute*
```

_*Development happens automatically (edit mode: auto) or with approval (edit mode: manual)_

Each step produces structured markdown files that feed into the next stage, creating full traceability from original requirements to shipped code.

## Features

- **📝 Epic Creation** - Parse PRDs/tech specs into manageable epics
- **📖 Story Generation** - Convert epics into detailed user stories
- **🔧 Spec Creation** - Transform stories into technical specifications
- **⚡ Auto Implementation** - Execute specs using Claude's autonomous planning system
- **🔗 Full Traceability** - Track from requirement → epic → story → spec → code
- **📦 Git Integration** - Conventional commits with semantic versioning (auto-created, never auto-pushed)
- **🎯 Quality Control** - Built-in validation at each stage

## What's New in v2.1.2

**🔧 Enhanced Commit Management:**

- **📝 New `/sl-commit` Command** - Intelligent git commit message generation using conventional commit standards
- **🎯 Semantic Commit Format** - Automatic prefix selection (feat:/fix:/chore:) based on change analysis
- **📊 Better Commit Quality** - 50-char summaries, detailed descriptions, consistent formatting
- **🔒 Safe Workflow** - Commits created automatically but **never auto-pushed** - you control when to push
- **🛠️ Standalone Usage** - Use `/sl-commit` for any repository changes, not just Storyline work
- **🤖 Auto-Integration** - `/sl-develop` automatically creates commits using the new system

**⚡ Standalone Stories (No Epic Required):**

- **🎯 Quick Workflow** - Create stories for bug fixes, small features, or tasks without needing a full epic
- **📝 Guided Creation** - Run `/sl-story-creator` with no arguments for guided standalone story creation
- **📁 Hidden Directory** - Stored in `.storyline/stories/.standalone/` for easy organization
- **🔗 Full Pipeline Support** - Standalone stories work seamlessly with `/sl-spec-story` and `/sl-develop`
- **💡 Best For** - Bug fixes, quick enhancements, small features, and one-off tasks

## What's New in v2.1

**📦 Better Branding & Backward Compatibility:**

- **🎨 New Directory Name** - `.storyline/` replaces `.workflow/` for better branding and clarity
- **🔄 Seamless Migration** - Run `/sl-setup` to migrate existing v2.0 projects (takes seconds, preserves all work)
- **✅ Full Backward Compatibility** - All skills support both `.storyline/` (v2.1+) and `.workflow/` (v2.0 legacy)
- **🔍 Smart Detection** - Skills automatically detect which directory structure you're using

**Migrating from v2.0:**
If you have an existing project with `.workflow/`, simply run `/sl-setup` and choose to migrate. Or keep using `.workflow/` - everything still works!

## What's New in v2.0

**✨ Major enhancements for production projects:**

- **🎯 Setup & Onboarding** - New `/sl-setup` command for project initialization and status tracking
- **🏷️ Identifier System** - Optional tracking codes (JIRA tickets, feature IDs) that propagate through the entire chain
- **📁 Epic Subdirectories** - Stories and specs organized by epic for better scalability
- **🎭 Spec Strategies** - Flexible approaches: simple (1 story → 1 spec), complex (1 story → multiple specs), or combined (multiple stories → 1 spec)
- **📊 Multi-Initiative Support** - Multiple PRDs with different identifiers can coexist in one project
- **🧭 Guided PRD Creation** - Run `/sl-epic-creator` without arguments for interactive PRD creation

**Directory structure (v2.1+):**
```
.storyline/
├── PRD-{identifier}.md        # Multiple PRDs supported
├── epics/
│   ├── epic-{id}-01-auth.md   # Identifiers in filenames
│   └── epic-{id}-02-tasks.md
├── stories/
│   ├── .standalone/           # Standalone stories (no epic required)
│   │   ├── story-fix-login-validation.md
│   │   └── story-add-export-button.md
│   ├── epic-{id}-01/          # Organized by epic
│   │   ├── story-01.md
│   │   └── story-02.md
│   └── epic-{id}-02/
│       └── story-01.md
└── specs/
    ├── .standalone/           # Specs from standalone stories
    │   ├── spec-fix-login-validation.md
    │   └── spec-add-export-button.md
    ├── epic-{id}-01/          # Organized by epic
    │   ├── spec-01.md
    │   └── spec-stories-02-03-combined.md
    └── epic-{id}-02/
        └── spec-01.md
```

## Installation

### Requirements

**Linux, macOS, or WSL (Windows Subsystem for Linux)** are recommended.

- **Windows users:** [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install) is strongly recommended for the best experience.
- **Experimental:** Native Windows PowerShell support is available but may have line ending issues with the remote installer. Manual installation works reliably.

### One-Line Install

**Linux/macOS/WSL:**
```bash
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash
```

**Windows (PowerShell) - Experimental:**
```powershell
iwr -useb https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.ps1 | iex
```

**Note:** Due to line ending issues, the remote PowerShell installer may not work reliably. For Windows native, we recommend using WSL or the manual installation method below.

This will:
1. Clone Storyline with all dependencies (using git submodules)
2. Install everything to `~/.local/share/storyline`
3. Copy skills and commands to `~/.claude/`

### Manual Installation

**Linux/macOS/WSL:**
```bash
git clone --recurse-submodules https://github.com/prillcode/storyline.git
cd storyline
chmod +x install.sh
./install.sh
```

**Windows (PowerShell) - Recommended for native Windows:**
```powershell
git clone --recurse-submodules https://github.com/prillcode/storyline.git
cd storyline
.\install.ps1
```

The `--recurse-submodules` flag automatically includes the cc-resources dependency. If you forget the flag, the installer will offer to initialize submodules for you.

**Note:** Manual installation via PowerShell works reliably. The remote one-line installer above may have issues due to line ending conversion.

### Advanced: Windows Native (Step-by-Step File Copy)

If you prefer to manually copy files without running the installer script:

**Step 1: Clone the repository with submodules**
```powershell
git clone --recurse-submodules https://github.com/prillcode/storyline.git
cd storyline
```

**Step 2: Create Claude directories (if they don't exist)**
```powershell
New-Item -ItemType Directory -Force -Path "$HOME\.claude\skills"
New-Item -ItemType Directory -Force -Path "$HOME\.claude\commands"
New-Item -ItemType Directory -Force -Path "$HOME\.claude\agents"
```

**Step 3: Copy dependency files**
```powershell
Copy-Item -Path ".\dependencies\cc-resources\skills\*" -Destination "$HOME\.claude\skills\" -Recurse -Force
Copy-Item -Path ".\dependencies\cc-resources\commands\*" -Destination "$HOME\.claude\commands\" -Recurse -Force
Copy-Item -Path ".\dependencies\cc-resources\agents\*" -Destination "$HOME\.claude\agents\" -Recurse -Force
```

**Step 4: Copy Storyline files**
```powershell
Copy-Item -Path ".\skills\*" -Destination "$HOME\.claude\skills\" -Recurse -Force
Copy-Item -Path ".\commands\*" -Destination "$HOME\.claude\commands\" -Recurse -Force
```

**Note:** This approach bypasses installation scripts and directly copies skill/command files. No compilation or line-ending issues involved - just file copying.

### Updating Storyline

To update to the latest version, re-run the one-line installer:

**Linux/macOS/WSL:**
```bash
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash
```

**Windows (PowerShell) - Experimental:**
```powershell
iwr -useb https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.ps1 | iex
```

**Note:** The remote installer may have line ending issues. Use manual update method below for best results.

Or if you cloned manually (recommended for Windows):

**Linux/macOS/WSL:**
```bash
cd storyline
git pull origin main
git submodule update --init --recursive
./install.sh
```

**Windows (PowerShell):**
```powershell
cd storyline
git pull origin main
git submodule update --init --recursive
.\install.ps1
```

### Verify Installation

Start a new Claude Code session and run:
```
/sl-setup check
```

This verifies all Storyline components are installed correctly.

## Quick Start

### 1. Initialize Your Project

```bash
/sl-setup init
```

This creates the `.storyline/` directory structure.

### 2. Create Your First Epic

**Option A: With existing PRD**
```bash
/sl-epic-creator docs/PRD.md
```
You'll be prompted for an optional identifier (e.g., `JIRA-123`).

**Option B: Guided mode (no PRD yet)**
```bash
/sl-epic-creator
```
Answer a few questions to generate your PRD and epics interactively.

Creates:
```
.storyline/
├── PRD-jira-123.md           # If identifier provided
└── epics/
    ├── epic-jira-123-01-authentication.md
    ├── epic-jira-123-02-task-management.md
    └── epic-jira-123-03-categories.md
```

### 3a. Create Stories from Epic

```bash
/sl-story-creator .storyline/epics/epic-jira-123-01-authentication.md
```

Creates:
```
.storyline/stories/epic-jira-123-01/
├── story-01.md          # User signup
├── story-02.md          # User login
└── story-03.md          # Password reset
```

### 3b. Create Standalone Story (No Epic Required)

**New in v2.1.2:** For bug fixes, small features, or quick tasks that don't need a full epic:

```bash
/sl-story-creator
```

This launches a guided workflow that prompts you for:
- Work type (bug fix, small feature, enhancement, task)
- Title and description
- User persona and acceptance criteria

Creates:
```
.storyline/stories/.standalone/
└── story-fix-login-validation.md
```

### 4. Generate Technical Spec

**From epic-based story:**
```bash
/sl-spec-story .storyline/stories/epic-jira-123-01/story-01.md
```

You'll choose a spec strategy:
- Simple: One story → one spec
- Complex: One story → multiple specs
- Combined: Multiple stories → one spec

Creates:
```
.storyline/specs/epic-jira-123-01/spec-01.md
```

**From standalone story:**
```bash
/sl-spec-story .storyline/stories/.standalone/story-fix-login-validation.md
```

Standalone stories always use simple strategy (1 story → 1 spec).

Creates:
```
.storyline/specs/.standalone/spec-fix-login-validation.md
```

### 5. Implement the Code

```bash
/sl-develop .storyline/specs/epic-jira-123-01/spec-01.md
```

This uses the underlying `create-plans` skill to:
- Break spec into atomic tasks
- Execute implementation
- Run tests and verification
- Create git commits
- Generate SUMMARY.md

### 6. Check Your Progress

```bash
/sl-setup status
```

Shows what you've created and suggests next steps.

## Project Structure

When using Storyline v2.0, your project follows this structure:

```
my-project/
├── .storyline/
│   ├── README.md                      # Quick reference guide
│   ├── PRD-jira-123.md                # Product requirements (with identifier)
│   ├── PRD-feature-789.md             # Multiple PRDs supported
│   ├── epics/
│   │   ├── epic-jira-123-01-auth.md   # Identifier propagates
│   │   ├── epic-jira-123-02-tasks.md
│   │   └── epic-feature-789-01-export.md
│   ├── stories/                       # Organized by epic + standalone
│   │   ├── .standalone/               # Standalone stories (no epic)
│   │   │   ├── story-fix-login.md
│   │   │   ├── story-add-export.md
│   │   │   └── INDEX.md
│   │   ├── epic-jira-123-01/
│   │   │   ├── story-01.md
│   │   │   ├── story-02.md
│   │   │   └── INDEX.md
│   │   ├── epic-jira-123-02/
│   │   │   └── story-01.md
│   │   └── epic-feature-789-01/
│   │       └── story-01.md
│   ├── specs/                         # Organized by epic + standalone
│   │   ├── .standalone/               # Specs from standalone stories
│   │   │   ├── spec-fix-login.md
│   │   │   └── spec-add-export.md
│   │   ├── epic-jira-123-01/
│   │   │   ├── spec-01.md
│   │   │   └── spec-stories-02-03-combined.md
│   │   └── epic-jira-123-02/
│   │       └── spec-01.md
│   └── .planning/                     # Generated by create-plans
│       └── jira-123-01-spec-01/
│           ├── PLAN.md
│           └── SUMMARY.md
└── src/                               # Your actual code
```

## Commands Reference

### `/sl-setup [command]`

Initialize, manage, and check Storyline projects.

**Usage:**
- `/sl-setup` - Interactive setup and onboarding
- `/sl-setup init` - Initialize `.storyline/` directory structure
- `/sl-setup status` - Show project state and suggest next steps
- `/sl-setup guide` - Display full tutorial
- `/sl-setup check` - Verify installation

### `/sl-epic-creator [prd-file]`

Parse a PRD or technical spec into one or more epics.

**New in v2.0:** Run without arguments for guided PRD creation with optional identifier.

**Input:** PRD markdown file
**Output:** Epic files in `.storyline/epics/`

**Options:**
- Single epic mode (small features)
- Multi-epic mode (large projects)

### `/sl-story-creator [epic-file]`

Generate user stories from an epic OR create standalone stories.

**Mode 1: From epic**
```bash
/sl-story-creator .storyline/epics/epic-001-auth.md
```
**Output:** Story files in `.storyline/stories/epic-{id}/`

**Mode 2: Standalone (no epic required)**
```bash
/sl-story-creator
```
Guided workflow for bug fixes, small features, quick tasks.
**Output:** Story files in `.storyline/stories/.standalone/`

**Features:**
- Validates story format
- Ensures INVEST criteria
- Links to parent epic (epic-based) or marks as standalone
- Supports optional tracking identifiers

### `/sl-spec-story <story-file>`

Create technical specification from a user story (epic-based or standalone).

**Input:** Story markdown file (epic-based or standalone)
**Output:** Technical spec in `.storyline/specs/` (organized by epic or in `.standalone/`)

**Epic-based stories:**
- Prompted to choose spec strategy (simple/complex/combined)
- Output: `.storyline/specs/epic-{id}/spec-{nn}.md`

**Standalone stories:**
- Always simple strategy (1 story → 1 spec)
- Output: `.storyline/specs/.standalone/spec-{slug}.md`

**Includes:**
- Architecture decisions
- File changes required
- Testing requirements
- Acceptance criteria

### `/sl-develop <spec-file>`

Execute the technical spec and implement the code.

**Input:** Technical spec file
**Output:** Working code + SUMMARY.md

**Process:**
1. Converts spec to PLAN.md format
2. Invokes `create-plans` for execution
3. Breaks work into atomic tasks (2-3 per plan)
4. Executes with quality controls
5. Creates git commits automatically using `/sl-commit`
6. Generates summary linking back to story

### `/sl-commit [message]`

Create a git commit with conventional commit message format.

**New in v2.1.2:** Intelligent commit message generation following conventional commit standards.

**Features:**
- Analyzes git diff to understand changes
- Generates semantic commit messages (feat:/fix:/chore:)
- 50-character summary limit
- Detailed bulleted descriptions
- Maintains project commit style consistency
- **Never auto-pushes** - only notifies when commits are ready to push

**Usage:**
- `/sl-commit` - Analyzes changes and creates commit automatically
- `/sl-commit "Custom message"` - Create commit with custom message
- Can be used for any repository changes, not just Storyline work

**Automatic Integration:**
- Invoked automatically by `/sl-develop` after implementation
- Can also be used standalone for manual commits

## Example Workflow

See `examples/sample-workflow/` for a complete example with:
- Sample PRD
- Generated epics
- User stories
- Technical specs
- Implementation summaries

## Dependencies

Storyline is built on top of claude skills and commands available in the [prillcode/cc-resources repo](https://github.com/prillcode/cc-resources) - a fork of [taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources) by glittercowboy.

**Required skills from taches:**
- `create-plans` - Hierarchical project planning and execution
- `create-agent-skills` - Skill creation framework
- `create-meta-prompts` - Staged workflow generation

See [CREDITS.md](./CREDITS.md) for full attribution.

## How It Works

Storyline uses Claude Code's **skill system** to create autonomous workflows:

1. **Skills** - Located in `~/.claude/skills/`, each skill is a router that loads appropriate workflows based on context
2. **Commands** - Slash commands in `~/.claude/commands/` that invoke skills with arguments
3. **Progressive Disclosure** - Skills only load the reference files needed for the current workflow
4. **Quality Gates** - Built-in validation at each stage prevents garbage-in-garbage-out

Each skill follows the router pattern:
```
skill-name/
├── SKILL.md              # Router + principles
├── workflows/            # Step-by-step procedures
├── references/           # Domain knowledge
└── templates/            # Output structures
```

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) first.

**Areas for contribution:**
- New workflow stages (testing stories, deployment stories)
- Template improvements
- Validation enhancements
- Integration with project management tools
- Documentation improvements

## License

MIT License - see [LICENSE](./LICENSE)

## Credits

Built by [prillcode](https://github.com/prillcode)

Storyline is built on the excellent [taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources) framework by glittercowboy. See [CREDITS.md](./CREDITS.md) for detailed attribution.

## Support

- **Issues**: [GitHub Issues](https://github.com/prillcode/storyline/issues)
- **Discussions**: [GitHub Discussions](https://github.com/prillcode/storyline/discussions)
- **Documentation**: [docs/](./docs/)

---

**Happy building!** 📖✨
