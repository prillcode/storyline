# Official Plugin Marketplace Submission Guide

This document tracks the submission of Storyline to the official Claude Code plugin marketplace.

## Submission Information

**Plugin Name:** storyline
**Repository:** https://github.com/prillcode/storyline
**Version:** 0.21.5
**Author:** Aaron Prill (prillcode@gmail.com)
**Homepage:** https://storyline.apcode.dev

## Submission Checklist

### Pre-Submission Requirements

- [x] Plugin manifest (`.claude-plugin/plugin.json`) complete
- [x] README.md with clear documentation
- [x] LICENSE file (MIT)
- [x] Plugin structure follows official standards:
  - [x] `.claude-plugin/` directory with plugin.json
  - [x] `commands/` directory with slash commands
  - [x] `skills/` directory with skill definitions
  - [x] `README.md` documentation
  - [x] Bundled dependencies in `cc-resources/`
- [x] Examples and documentation provided
- [x] Version 0.21.5 published to GitHub main branch

### Submission Process

1. **Submit via Official Form**
   - URL: https://clau.de/plugin-directory-submission
   - Status: ⏳ Pending submission
   - Date: [To be filled]

2. **Information to Provide**
   - Plugin name: storyline
   - Repository URL: https://github.com/prillcode/storyline
   - Description: Story-driven development workflow - transform PRDs into code through Epic → Story → Spec → Implementation pipeline
   - Version: 0.21.5
   - Homepage: https://storyline.apcode.dev
   - Author: Aaron Prill
   - License: MIT

3. **Quality Standards**
   - ✅ Clear, comprehensive documentation
   - ✅ Working examples provided
   - ✅ Proper error handling in skills
   - ✅ Progressive disclosure pattern (context optimization)
   - ✅ Router pattern for complex skills
   - ✅ Bundled dependencies included
   - ✅ No external dependencies required

4. **Security Considerations**
   - ✅ No malicious code
   - ✅ No unauthorized data collection
   - ✅ All file operations within user's project directory
   - ✅ Git operations never auto-push (user control)
   - ✅ Clear documentation of what the plugin does

## Post-Submission

### Expected Timeline
- Submission review: Unknown (check recent PR activity in anthropics/claude-plugins-official)
- Approval criteria: Quality and security standards (see official repo)

### Testing After Approval
Once approved, test installation:
```bash
/plugin marketplace add anthropics/claude-plugins-official
/plugin install storyline
/sl-setup check
```

### Interim Solution
While awaiting approval, users can install via custom marketplace:
```bash
/plugin marketplace add https://github.com/prillcode/storyline
/plugin install storyline
/sl-setup check
```

## References

- **Official Plugin Repository:** https://github.com/anthropics/claude-plugins-official
- **Submission Form:** https://clau.de/plugin-directory-submission
- **Plugin Documentation:** https://code.claude.com/docs/en/plugins
- **Discovery Docs:** https://code.claude.com/docs/en/discover-plugins

## Notes

- Anthropic reviews all submissions for quality and security
- External plugins must meet their standards for approval
- Users should trust plugins before installation (standard security notice)
- Plugin marketplace is actively maintained (check recent PRs)

## Next Steps

1. ✅ Complete this document
2. ⏳ Submit via https://clau.de/plugin-directory-submission
3. ⏳ Monitor submission status
4. ⏳ Test installation after approval
5. ⏳ Update README to reflect official marketplace availability
