# Storyline v2.1.0 Release Notes

**Release Date:** January 12, 2026

## Overview

Storyline v2.1.0 is a refinement release that improves branding and project clarity by renaming the root directory from `.workflow/` to `.storyline/`. This release maintains full backward compatibility with v2.0 projects while providing an easy migration path for those who want to adopt the new naming.

## What's New

### 🎨 New Directory Name: `.storyline/`

The primary project directory has been renamed from `.workflow/` to `.storyline/` for better branding and clarity:

**Why the change?**
- **Better branding** - "Storyline" is the product name, so `.storyline/` makes more sense
- **Clearer purpose** - The directory contains storyline artifacts (epics, stories, specs)
- **Consistency** - Aligns the directory name with the product identity

**New structure:**
```
.storyline/
├── PRD-{identifier}.md
├── epics/
│   ├── epic-{id}-01-auth.md
│   └── epic-{id}-02-tasks.md
├── stories/
│   ├── epic-{id}-01/
│   └── epic-{id}-02/
├── specs/
│   ├── epic-{id}-01/
│   └── epic-{id}-02/
└── .planning/
```

### 🔄 Seamless Migration

Migrating from `.workflow/` to `.storyline/` is easy and optional:

**Option 1: Interactive Migration**
```bash
/sl-setup
```
- Detects existing `.workflow/` projects
- Prompts to migrate to `.storyline/`
- Migration is a simple directory move (takes seconds)
- All work is preserved - nothing is lost

**Option 2: Keep Using `.workflow/`**
- All skills support both directory names
- No migration required if you prefer to keep `.workflow/`
- Skills automatically detect which directory you're using
- Full backward compatibility guaranteed

### ✅ Full Backward Compatibility

All Storyline skills now support both directory structures:

- **Smart detection** - Skills check `.storyline/` first, then fall back to `.workflow/`
- **No breaking changes** - Existing v2.0 projects work without modification
- **Flexible** - Mix of old and new projects in the same workspace
- **Subdirectory support** - Both lowercase and UPPERCASE subdirectories supported in both structures

**Detection logic in all skills:**
```bash
if [ -d ".storyline" ]; then
  ROOT_DIR=".storyline"
elif [ -d ".workflow" ]; then
  ROOT_DIR=".workflow"
fi
```

### 📚 Updated Documentation

All documentation, templates, and examples now use `.storyline/`:

- **README.md** - Updated with v2.1 changes and migration guide
- **All skills** - Documentation references `.storyline/` as primary
- **Templates** - All templates updated to `.storyline/`
- **Reference docs** - Updated with backward compatibility notes
- **Examples** - Show `.storyline/` structure

## Migration Guide

### For New Projects

Just run `/sl-setup init` - you'll get the new `.storyline/` structure automatically.

### For Existing v2.0 Projects

**Option A: Migrate (Recommended)**

1. Run `/sl-setup` in your project
2. Choose "Yes, migrate now" when prompted
3. Done! Your `.workflow/` is now `.storyline/`

**Option B: Keep Using `.workflow/`**

1. Do nothing!
2. Everything continues to work
3. All skills support `.workflow/` indefinitely

**Manual Migration (if needed):**
```bash
mv .workflow .storyline
```

That's it! The directory structure inside is identical.

## Breaking Changes

**None!** This is a fully backward-compatible release.

- Existing `.workflow/` projects work without any changes
- No skill behavior changes beyond directory detection
- No file format changes
- No workflow changes

## Technical Details

### Files Changed

**Skills updated:**
- `storyline-setup` - Added migration logic and detection
- `storyline-epic-creator` - Added directory detection
- `storyline-story-creator` - Added directory detection
- `storyline-spec-story` - Added directory detection
- `storyline-develop` - Added directory detection

**Documentation updated:**
- `README.md` - New v2.1 section and migration guide
- All skill references - Updated to `.storyline/` with backward compatibility notes
- All templates - Updated to `.storyline/`
- All examples - Updated to `.storyline/`

**Version bumped:**
- `package.json` - Version updated to 2.1.0

### Directory Detection Pattern

All skills now use this pattern:

```bash
# Check .storyline/ first (v2.1+)
if [ -d ".storyline" ]; then
  ROOT_DIR=".storyline"
# Fall back to .workflow/ (v2.0)
elif [ -d ".workflow" ]; then
  ROOT_DIR=".workflow"
else
  echo "No Storyline project found. Run /sl-setup init"
  exit 1
fi
```

This ensures:
1. New projects use `.storyline/`
2. Old projects using `.workflow/` still work
3. Migration is detected and prompted
4. No breaking changes

### Subdirectory Support

Both `.storyline/` and `.workflow/` support:
- Lowercase subdirectories: `epics/`, `stories/`, `specs/` (preferred)
- Uppercase subdirectories: `EPICS/`, `STORIES/`, `SPECS/` (also supported)

Skills detect which case is used and adapt accordingly.

## Testing

Tested scenarios:
- ✅ Fresh project initialization creates `.storyline/`
- ✅ Migration from `.workflow/` to `.storyline/` preserves all files
- ✅ Existing `.workflow/` projects work without migration
- ✅ Mixed case subdirectories work in both structures
- ✅ All skills detect correct directory automatically
- ✅ `/sl-setup status` works with both structures
- ✅ Full epic → story → spec → develop workflow with both structures

## Upgrade Instructions

### Installation

**One-line installer:**
```bash
curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash
```

**Manual update:**
```bash
cd storyline
git pull origin main
git submodule update --init --recursive
./install.sh
```

### Post-Installation

**For new projects:**
- Just run `/sl-setup init` and you're done

**For existing v2.0 projects:**
- Run `/sl-setup` to see migration prompt
- Or continue using `.workflow/` - both work!

## Deprecation Notice

**`.workflow/` is NOT deprecated!**

While `.storyline/` is now the preferred name:
- `.workflow/` will be supported indefinitely
- No plans to remove `.workflow/` support
- Choose whichever name you prefer

## Contributors

- **prillcode** - All changes in this release

## Links

- **GitHub**: https://github.com/prillcode/storyline
- **Issues**: https://github.com/prillcode/storyline/issues
- **Discussions**: https://github.com/prillcode/storyline/discussions

---

**Happy building with Storyline v2.1!** 🎉
