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
[epic-creator] [story] [spec-story]  [develop]      [create-plans]
```

Each step produces structured markdown files that feed into the next stage, creating full traceability from original requirements to shipped code.

## Features

- **📝 Epic Creation** - Parse PRDs/tech specs into manageable epics
- **📖 Story Generation** - Convert epics into detailed user stories
- **🔧 Spec Creation** - Transform stories into technical specifications
- **⚡ Auto Implementation** - Execute specs using Claude's autonomous planning system
- **🔗 Full Traceability** - Track from requirement → epic → story → spec → code
- **📦 Git Integration** - Automatic commits with proper attribution
- **🎯 Quality Control** - Built-in validation at each stage

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
│   ├── epic-{id}-01/          # Organized by epic
│   │   ├── story-01.md
│   │   └── story-02.md
│   └── epic-{id}-02/
│       └── story-01.md
└── specs/
    ├── epic-{id}-01/          # Organized by epic
    │   ├── spec-01.md
    │   └── spec-stories-02-03-combined.md
    └── epic-{id}-02/
        └── spec-01.md
```

## Installation

### Option 1: One-Line Remote Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash
```

This will:
1. Clone Storyline with all dependencies (using git submodules)
2. Install everything to `~/.local/share/storyline`
3. Copy skills and commands to `~/.claude/`

### Option 2: Clone and Install

```bash
git clone --recurse-submodules https://github.com/prillcode/storyline.git
cd storyline
chmod +x install.sh
./install.sh
```

The `--recurse-submodules` flag automatically includes the cc-resources dependency.

If you forget the flag, the installer will offer to initialize submodules for you.

### Option 3: Manual Install

```bash
# Clone with dependencies
git clone --recurse-submodules https://github.com/prillcode/storyline.git
cd storyline

# Manually copy files
cp -r dependencies/cc-resources/skills/* ~/.claude/skills/
cp -r dependencies/cc-resources/commands/* ~/.claude/commands/
cp -r dependencies/cc-resources/agents/* ~/.claude/agents/
cp -r skills/* ~/.claude/skills/
cp -r commands/* ~/.claude/commands/
```

### Updating Storyline

To update to the latest version:

```bash
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash
```

Or if you cloned manually:

```bash
cd storyline
git pull origin main
git submodule update --init --recursive
./install.sh
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

### 3. Create Stories from Epic

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

### 4. Generate Technical Spec

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
│   ├── stories/                       # Organized by epic
│   │   ├── epic-jira-123-01/
│   │   │   ├── story-01.md
│   │   │   ├── story-02.md
│   │   │   └── INDEX.md
│   │   ├── epic-jira-123-02/
│   │   │   └── story-01.md
│   │   └── epic-feature-789-01/
│   │       └── story-01.md
│   ├── specs/                         # Organized by epic
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

### `/sl-story-creator <epic-file>`

Generate user stories from an epic.

**Input:** Epic markdown file
**Output:** Story files in `.storyline/stories/`

**Features:**
- Validates story format
- Ensures INVEST criteria
- Links back to parent epic

### `/sl-spec-story <story-file>`

Create technical specification from a user story.

**Input:** Story markdown file
**Output:** Technical spec in `.storyline/specs/`

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
5. Creates git commits
6. Generates summary linking back to story

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
