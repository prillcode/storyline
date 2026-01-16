# Storyline Plugin Migration Plan

## Executive Summary

Migrate Storyline from bash script installation to Claude Code's native plugin marketplace system. **All dependencies are bundled** - users install just ONE plugin.

**Target outcome:** Users install with `/plugin marketplace add prillcode/storyline` followed by `/plugin install storyline` - that's it!

---

## Current State Analysis

### Current Installation Method
```bash
# One-line install
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash

# OR Manual install
git clone --recurse-submodules https://github.com/prillcode/storyline.git
cd storyline
./install.sh
```

**Current process:**
1. Clone repository with `--recurse-submodules` flag to pull cc-resources
2. Bash script copies files from both locations to `~/.claude/`
3. Requires bash (problematic for Windows native users)
4. Manual update process
5. Confusing git submodule concept for contributors

**Issues with current approach:**
- Requires bash (Windows users need WSL)
- Requires understanding of git submodules
- Manual update process
- No version management
- Not discoverable in Claude Code plugin UI
- Cross-platform installation friction

---

## New Approach: Single Bundled Plugin

### Architecture

**ONE plugin** that includes everything:
- Storyline-specific skills (epic-creator, story-creator, spec-story, develop, commit)
- Storyline commands (all /sl-* commands)
- Foundation skills from cc-resources (create-plans, meta-prompts, etc.)
- Bundled dependencies - users don't need to know cc-resources exists

### Why Bundle Instead of Separate Plugins?

**Advantages:**
- ✅ **Simplest user experience**: One command to install
- ✅ **No dependency confusion**: No "install cc-resources first" instructions
- ✅ **Cleaner mental model**: "Storyline is one thing"
- ✅ **Easier testing**: One plugin to test, one version to track
- ✅ **You control the exact versions**: No version conflicts between plugins
- ✅ **Cross-platform by default**: Works on Windows, Mac, Linux
- ✅ **Proven pattern**: This is how taches-cc-resources itself works

**Why this works:**
- cc-resources content is stable - not many upstream changes expected
- You manage the cc-resources fork already
- Storyline always needs the same cc-resources features
- Most users don't care about the internal dependencies

**Trade-offs:**
- Need to manually sync upstream cc-resources changes (low frequency)
- Slightly larger repo (but not an issue with modern Git)
- cc-resources is "hidden" from users (but they don't need to know)

---

## Versioning Strategy

### Semantic Versioning: 0.x Format

Using **0.21.5** format signals:
- ✅ Pre-1.0 = Beta/Pre-release software
- ✅ Breaking changes OK (per semver spec, 0.x.y can have breaking changes)
- ✅ Room to grow toward 1.0.0 stable release
- ✅ Clear progression path

**Version mapping (old → new):**
- v2.1.4 → v0.21.4 (existing release)
- v2.1.5 → **v0.21.5** (first plugin release)
- v2.2.0 → v0.22.0 (future minor release)
- Future stable → v1.0.0 (when ready for production)

**When to release 1.0.0:**
- Plugin installation proven stable (2+ months)
- API/workflow stabilized (no breaking changes planned)
- Feature complete for core workflow
- Production-ready quality

### Git Tagging Strategy

```bash
# Current plugin release
git tag v0.21.5
git push origin v0.21.5

# Future releases
git tag v0.21.6  # Patch: bug fixes
git tag v0.22.0  # Minor: new features, backward compatible
git tag v1.0.0   # Major: stable release!
```

---

## Repository Structure Changes

### Before (with submodule)
```
storyline/
├── .gitmodules                  # Submodule config
├── dependencies/
│   └── cc-resources/            # Git submodule (confusing!)
├── skills/
├── commands/
└── install.sh
```

### After (bundled) ✅
```
storyline/
├── .claude-plugin/
│   └── plugin.json              # NEW: Plugin metadata
├── cc-resources/                # NEW: Bundled (not a submodule!)
│   ├── skills/
│   │   ├── create-plans/        # The big one!
│   │   ├── create-agent-skills/
│   │   ├── create-subagents/
│   │   └── ...
│   ├── commands/
│   ├── agents/
│   └── LICENSE                  # Attribution preserved
├── skills/                      # Storyline skills
│   ├── storyline-setup/
│   ├── storyline-epic-creator/
│   └── ...
├── commands/                    # Storyline commands
│   ├── sl-setup.md
│   ├── sl-epic-creator.md
│   └── ...
├── install.sh                   # Updated to use cc-resources/ path
└── README.md
```

**Key changes:**
- ✅ `.claude-plugin/plugin.json` created
- ✅ `dependencies/cc-resources` → `cc-resources/` (no longer submodule)
- ✅ `.gitmodules` removed
- ✅ Simpler structure, easier to understand

---

## Implementation Checklist

### ✅ Phase 1: Repository Restructure (COMPLETED)

- [x] Copy cc-resources files from `../cc-resources` to `storyline/cc-resources/`
- [x] Remove git submodule configuration
- [x] Remove `.gitmodules` file
- [x] Create `.claude-plugin/` directory
- [x] Create `plugin.json` with version 0.21.5

### Phase 2: Update Scripts and Docs

#### Update install.sh
Change paths from `dependencies/cc-resources` → `cc-resources`:

```bash
# OLD
DEPENDENCY_DIR="$SCRIPT_DIR/dependencies/cc-resources"

# NEW
DEPENDENCY_DIR="$SCRIPT_DIR/cc-resources"
```

#### Update remote-install.sh
- Remove `--recurse-submodules` flag (no longer needed!)
- Update version reference to v0.21.5

#### Update README.md
Add plugin installation as **primary method**:

```markdown
## Installation

### Plugin Installation (Recommended)

The simplest way to install Storyline:

**Step 1: Add the Storyline marketplace**
```
/plugin marketplace add prillcode/storyline
```

**Step 2: Install Storyline**
```
/plugin install storyline
```

**Step 3: Verify installation**

Start a new Claude Code session and run:
```
/sl-setup check
```

That's it! All dependencies are included.

**Updating:** Use `/plugin update storyline` or enable auto-updates.

### Script Installation (Alternative)

For offline installation or advanced customization:

**One-line install:**
```bash
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash
```

**Manual install:**
```bash
git clone https://github.com/prillcode/storyline.git
cd storyline
./install.sh
```

Note: No more `--recurse-submodules` needed!
```

#### Update CLAUDE.md
```markdown
## Dependencies

Storyline bundles the following skills from [prillcode/cc-resources](https://github.com/prillcode/cc-resources):
- `create-plans` - Hierarchical project planning and execution
- `create-agent-skills` - Skill creation framework
- `create-meta-prompts` - Staged workflow generation

Located in `cc-resources/` directory. See [CREDITS.md](./CREDITS.md) for attribution.
```

#### Update CREDITS.md
Add clear attribution:

```markdown
## Bundled Dependencies

Storyline includes skills from [prillcode/cc-resources](https://github.com/prillcode/cc-resources),
a fork of [taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources) by
[glittercowboy](https://github.com/glittercowboy).

**Bundled skills in `cc-resources/`:**
- create-plans
- create-agent-skills
- create-subagents
- create-meta-prompts
- And more...

See `cc-resources/LICENSE` for license details (MIT).

Thank you to glittercowboy for creating the foundation that makes Storyline possible!
```

#### Update version references in docs
Replace version numbers (move decimal):
- v2.1.4 → v0.21.4
- v2.1.2 → v0.21.2
- v2.1.0 → v0.21.0
- v2.0.0 → v0.20.0

**Files to update:**
- [x] README.md header section
- [ ] docs/RELEASE_NOTES_v2.0.0.md → rename/archive
- [ ] docs/RELEASE_NOTES_v2.1.0.md → rename/archive
- [ ] Any inline version references

### Phase 3: GitHub Repository Cleanup

#### Delete old releases
To avoid confusion with new versioning:

**On GitHub:**
1. Go to Releases page
2. Delete releases: v2.1.4, v2.1.2, v2.1.0, v2.0.0
3. Or edit them to add deprecation notice

**Alternative (less disruptive):**
- Keep old releases but add notice: "⚠️ Old versioning scheme. See v0.21.5+ for new releases."

#### Create new release
1. Tag v0.21.5 in Git
2. Push tag to GitHub
3. Create GitHub release with notes:

```markdown
# v0.21.5 - Plugin Installation Support

## 🎉 Major Changes

**Plugin Installation Now Available!**

Install Storyline in one command:
```
/plugin marketplace add prillcode/storyline
/plugin install storyline
```

**New Versioning Scheme**

Adopting semantic versioning 0.x format:
- v0.21.5 = Pre-1.0 beta release
- Previous v2.1.4 mapped to v0.21.4 (old releases deprecated)
- Will release v1.0.0 when stable

## 🔄 Breaking Changes

**For developers/contributors:**
- Removed git submodule (cc-resources now bundled)
- Repo structure changed: `dependencies/cc-resources` → `cc-resources/`
- Install script updated to use new paths

**For users:**
- No breaking changes! Your `.storyline/` projects work unchanged
- Both plugin and script installation supported

## ✨ Features

- ✅ Plugin installation via Claude Code marketplace
- ✅ Cross-platform support (Windows, Mac, Linux)
- ✅ Auto-update capability via `/plugin update`
- ✅ Simplified installation (no more git submodules!)

## 📦 What's Included

All dependencies bundled - no separate installs needed:
- Storyline skills (epic-creator, story-creator, spec-story, develop, commit)
- Foundation skills (create-plans, meta-prompts, agent tools)
- All commands and agents

## 🚀 Installation

**Plugin (recommended):**
```
/plugin marketplace add prillcode/storyline
/plugin install storyline
```

**Script (alternative):**
```bash
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash
```

## 🙏 Credits

Built on [prillcode/cc-resources](https://github.com/prillcode/cc-resources),
forked from [taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources)
by glittercowboy.
```

### Phase 4: Testing

#### Local Testing

**Test plugin installation:**
```bash
cd /path/to/storyline
/plugin marketplace add ./
/plugin install storyline
```

**Verify:**
- [ ] All `/sl-*` commands available
- [ ] `/sl-setup check` passes
- [ ] Can run full workflow (PRD → Epic → Story → Spec → Implement)
- [ ] `create-plans` skill accessible
- [ ] Version shows as 0.21.5 in `/plugin list`

**Test script installation:**
```bash
./install.sh
# Verify same functionality
```

#### Cross-Platform Testing
- [ ] Test on macOS
- [ ] Test on Linux
- [ ] Test on WSL
- [ ] Test on Windows native (document limitations if any)

#### Update Testing
1. Make a change
2. Bump version to 0.21.6
3. Run `/plugin update storyline`
4. Verify update applied

### Phase 5: Documentation

Create new documentation files:

#### docs/PLUGIN_INSTALLATION.md
Detailed guide:
- How to add marketplace
- How to install plugin
- How to update
- How to uninstall
- Scoping options (user/project/local)
- Troubleshooting

#### docs/MIGRATION_TO_PLUGIN.md
For existing users:
- Why migrate
- Migration steps
- What happens to .storyline/ directories (nothing - they're safe!)
- Troubleshooting

#### Update existing docs
- [ ] README.md - Plugin as primary method
- [ ] CLAUDE.md - Remove submodule references
- [ ] CONTRIBUTING.md - Update dev setup instructions
- [ ] CREDITS.md - Add cc-resources attribution

---

## Rollout Plan

### Week 1: Prepare and Test
- [x] Restructure repository (remove submodule, bundle cc-resources)
- [x] Create plugin.json
- [ ] Update install.sh paths
- [ ] Update README with plugin installation
- [ ] Test locally with `/plugin marketplace add ./`
- [ ] Fix any bugs discovered

### Week 2: GitHub Release
- [ ] Update all version references (2.x.x → 0.2x.x)
- [ ] Tag v0.21.5
- [ ] Create GitHub release with announcement
- [ ] Delete or deprecate old releases (v2.x.x)
- [ ] Push all changes to main branch

### Week 3: Soft Launch
- [ ] Announce in Discord as "new plugin installation available"
- [ ] Ask 3-5 users to test and provide feedback
- [ ] Monitor GitHub issues
- [ ] Fix any critical bugs (release v0.21.6 if needed)

### Week 4: Public Launch
- [ ] Announce on GitHub Discussions
- [ ] Update website (storyline.apcode.dev) if applicable
- [ ] Share on social media
- [ ] Monitor adoption

### Month 2-3: Iterate
- [ ] Gather feedback
- [ ] Fix bugs (v0.21.x patches)
- [ ] Add features (v0.22.0 minor releases)
- [ ] Monitor installation success rate

### Month 3-6: Path to 1.0.0
- [ ] Stabilize API/workflow
- [ ] Comprehensive testing
- [ ] Documentation polish
- [ ] Consider official marketplace submission
- [ ] Release v1.0.0 when ready

---

## Maintenance Strategy

### Updating Bundled cc-resources

When you want to sync upstream changes from taches-cc-resources:

**In your cc-resources fork:**
```bash
cd /path/to/cc-resources
git remote add upstream https://github.com/glittercowboy/taches-cc-resources.git
git fetch upstream
git merge upstream/main
# Resolve conflicts if any
git push origin main
```

**Copy to Storyline:**
```bash
cd /path/to/storyline
cp -r ../cc-resources/skills/* cc-resources/skills/
cp -r ../cc-resources/commands/* cc-resources/commands/
cp -r ../cc-resources/agents/* cc-resources/agents/

# Test that everything still works
./install.sh
# Run tests

# Commit
git add cc-resources/
git commit -m "chore: Update bundled cc-resources to v1.x.x"
```

**Expected frequency:** Every 2-3 months or as needed

### Version Management

**Patch releases (0.21.x):**
- Bug fixes
- Documentation updates
- No breaking changes
- Fast iteration

**Minor releases (0.x.0):**
- New features
- New commands/skills
- Can have breaking changes (pre-1.0 allows this)
- Update bundled cc-resources if needed

**Major release (1.0.0):**
- Stable release
- API/workflow frozen
- Production ready
- After proven stability (3+ months)

### Git Workflow

**Before each release:**
```bash
# 1. Update version in plugin.json
# 2. Update CHANGELOG if you maintain one
# 3. Commit version bump
git commit -am "chore: Bump version to 0.21.6"

# 4. Tag
git tag v0.21.6
git push origin main
git push origin v0.21.6

# 5. Create GitHub release
```

---

## Migration Path for Users

### New Users
**Simple!** Just follow README plugin installation:
```
/plugin marketplace add prillcode/storyline
/plugin install storyline
```

### Existing Users (Script Installation)

**Option 1: Keep using scripts**
- Scripts will continue to work
- No need to migrate if you're happy
- Update via `git pull` and `./install.sh`

**Option 2: Migrate to plugin**
1. Optional: Run `./uninstall.sh` to clean up
2. Install via plugin (see Migration Guide)
3. Your `.storyline/` directories work unchanged!

**Recommendation:**
- Let users choose
- Document both methods
- Eventually (6+ months) deprecate scripts after plugin proven stable

---

## Success Metrics

### Quantitative Goals
- **Installation success rate**: >95% (vs ~85% for script)
- **Time to install**: <1 minute (vs 2-5 minutes for script)
- **Cross-platform**: Windows native support (currently 0%)
- **Update frequency**: Users update 2x more often (easier updates)
- **Issue reduction**: 50% fewer install-related issues

### Qualitative Goals
- User feedback: "Installation was easy"
- Discoverability: Users find via `/plugin` UI
- First-time success: Users get it working on first try
- Documentation clarity: Fewer "how do I install?" questions

### Track
- GitHub Issues: installation-related tags
- Discord: #help channel mentions of installation
- Plugin downloads (if visible)
- User testimonials/reviews

---

## Risk Mitigation

### Risk: Plugin system has limitations we discover

**Mitigation:**
- Keep script installation as fallback
- Document any platform-specific issues
- Report issues to Anthropic
- Community can contribute fixes

### Risk: Users confused by version number change

**Mitigation:**
- Clear documentation in release notes
- Deprecation notices on old releases
- FAQ explaining new versioning
- Discord announcement

### Risk: Breaking changes in cc-resources upstream

**Mitigation:**
- Test before merging upstream changes
- Pin to stable cc-resources versions
- Can choose not to merge breaking changes
- Control our own fork

### Risk: Low plugin adoption

**Mitigation:**
- Make plugin method MORE prominent in docs
- Highlight Windows support benefit
- Easier updates benefit
- Keep scripts available but secondary

---

## Post-Launch Tasks

### Immediately After v0.21.5 Launch
- [ ] Monitor GitHub issues for bug reports
- [ ] Watch Discord for installation questions
- [ ] Respond quickly to problems
- [ ] Document any edge cases discovered

### First Month
- [ ] Gather user feedback
- [ ] Fix critical bugs (patch releases)
- [ ] Update troubleshooting docs
- [ ] Track adoption metrics

### Month 2-3
- [ ] Plan next feature releases
- [ ] Consider official marketplace submission
- [ ] Improve documentation based on common questions
- [ ] Celebrate wins with community!

### Month 3-6
- [ ] Stabilize for 1.0.0 release
- [ ] Comprehensive testing
- [ ] Security review
- [ ] Performance optimization
- [ ] Polish documentation

---

## FAQ

### Why bundle cc-resources instead of separate plugin?

**Simplicity.** Users install one thing. No "install dependency first" confusion. Proven pattern (taches does this).

### What if cc-resources has breaking changes?

You control the fork. Test before merging. Can choose to not merge breaking changes or handle them in Storyline.

### Will old installations keep working?

Yes! Script installation remains supported. Your `.storyline/` directories work with both methods.

### How do I contribute to bundled cc-resources?

Contribute to [prillcode/cc-resources](https://github.com/prillcode/cc-resources) or upstream [taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources). Changes will be synced periodically.

### When will 1.0.0 be released?

When the workflow is stable, plugin installation proven, and no major changes planned. Target: 3-6 months.

### Can I install both plugin and script?

Technically yes, but not recommended. Choose one method to avoid confusion.

---

## Commands Quick Reference

### For Users

```bash
# Installation
/plugin marketplace add prillcode/storyline
/plugin install storyline

# Verification
/sl-setup check

# Updates
/plugin update storyline
/plugin update  # Update all plugins

# Management
/plugin list
/plugin remove storyline

# Marketplace
/plugin marketplace list
/plugin marketplace update
```

### For Developers

```bash
# Local testing
cd /path/to/storyline
/plugin marketplace add ./
/plugin install storyline

# After changes
# 1. Bump version in plugin.json
# 2. Test
# 3. Commit and tag

# Update bundled cc-resources
cp -r ../cc-resources/{skills,commands,agents} cc-resources/
# Test, commit
```

---

## References

- [Claude Code Plugin Documentation](https://code.claude.com/docs/en/discover-plugins)
- [Official Plugin Directory](https://github.com/anthropics/claude-plugins-official)
- [TÂCHES cc-resources](https://github.com/glittercowboy/taches-cc-resources)
- [Semantic Versioning](https://semver.org/)

---

## Next Steps

1. ✅ Repository restructure complete
2. **→ Update install.sh paths**
3. Update README.md with plugin installation
4. Update remote-install.sh (remove --recurse-submodules)
5. Update version references across docs
6. Test locally
7. Tag v0.21.5 and release
8. Announce to community

---

**Let's make Storyline the easiest Claude Code plugin to install! 🚀**
