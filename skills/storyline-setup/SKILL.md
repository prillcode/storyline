---
name: setup
description: Initialize and manage Storyline projects. Use for project setup, status checking, installation verification, and onboarding guidance. Supports multi-initiative projects with identifier-based organization.
---

<essential_principles>

<principle name="setup_first">
Setup is the entry point to Storyline.
New users should start with /sl-setup to understand the workflow.
Every project should have .workflow/ directory structure.
</principle>

<principle name="progressive_disclosure">
Don't overwhelm users with information.
Interactive mode guides users through one decision at a time.
Advanced features (identifiers, multi-PRD) revealed when relevant.
</principle>

<principle name="project_state_awareness">
Setup skill understands current project state.
Status command shows what exists, what's next.
Suggestions are contextual based on what user has done.
</principle>

<principle name="backward_compatible">
Respect existing .workflow/ structures from v1.
Support projects with and without identifiers.
Gracefully handle both flat and nested directory structures.
</principle>

<principle name="installation_health">
Check command verifies all Storyline components installed.
Helps users diagnose issues quickly.
Version information clearly displayed.
</principle>

</essential_principles>

<intake>
**Storyline setup and project management**

The /sl-setup command supports multiple modes:

**Interactive (default):**
```
/sl-setup
```
Comprehensive onboarding and project initialization.

**Specific commands:**
```
/sl-setup init      # Initialize .workflow/ directory structure
/sl-setup status    # Show current project state and suggest next steps
/sl-setup guide     # Display full onboarding tutorial
/sl-setup check     # Verify Storyline installation
```

**Wait for command mode before proceeding.**
</intake>

<routing>
Parse the arguments after /sl-setup:

**No argument or empty:**
→ workflows/interactive-setup.md
(Comprehensive onboarding flow)

**Argument: "init"**
→ workflows/init-project.md
(Create .workflow/ directory structure only)

**Argument: "status"**
→ workflows/show-status.md
(Analyze project state, suggest next actions)

**Argument: "guide"**
→ workflows/display-guide.md
(Show full tutorial and documentation)

**Argument: "check"**
→ workflows/verify-installation.md
(Verify all Storyline components installed)

**Unknown argument:**
Show error:
```
Unknown command: {argument}

Valid commands:
  /sl-setup          # Interactive setup
  /sl-setup init     # Initialize directories
  /sl-setup status   # Show project state
  /sl-setup guide    # Display tutorial
  /sl-setup check    # Verify installation
```
</routing>

<validation>
Before completing any workflow, verify:
- [ ] User understands next steps
- [ ] If directories created, confirm with ls
- [ ] If status shown, suggestions are actionable
- [ ] Links and paths use correct format
- [ ] Messages are concise and helpful
</validation>

<success_criteria>
Setup successful when:
1. User understands Storyline workflow
2. .workflow/ structure exists (if initialized)
3. User knows which command to run next
4. Installation verified (if check run)
5. No confusion about directory structure or identifiers
</success_criteria>

<reference_index>
## Domain Knowledge

All in `references/`:

**directory-structure.md** - Explanation of .workflow/ organization with and without identifiers
**workflow-patterns.md** - Common usage patterns and workflow examples
**troubleshooting.md** - Common issues and solutions
</reference_index>

<workflows_index>
## Workflows

All in `workflows/`:

| Workflow | Purpose |
|----------|---------|
| interactive-setup.md | Default comprehensive onboarding flow |
| init-project.md | Create .workflow/ directory structure |
| show-status.md | Analyze project state and suggest next steps |
| display-guide.md | Show full tutorial documentation |
| verify-installation.md | Check Storyline installation health |
</workflows_index>
