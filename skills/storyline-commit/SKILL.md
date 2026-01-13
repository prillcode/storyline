---
name: storyline-commit
description: Generates commits with clear commit messages from git diffs. Part of the Storyline workflow, but can also be used as standalone skill for any repository changes.
---

<skill>

<overview>
  <purpose>Generate conventional commit messages from git diffs with proper semantic prefixes and formatting</purpose>
  <benefit>Creates consistent, informative commit messages that follow conventional commit standards and explain what changed and why</benefit>
  <when_to_use>
    <case>User asks to create a git commit</case>
    <case>User asks to commit changes</case>
    <case>User needs help writing a commit message</case>
    <case>After implementing features or fixes that need to be committed</case>
  </when_to_use>
</overview>

<tool_restrictions>
  <allowed_tools>
    <tool name="Bash">Run git commands (diff, status, log, commit)</tool>
  </allowed_tools>
  <allowed_git_commands>
    <command>git diff HEAD - Analyze all changes (staged and unstaged)</command>
    <command>git status - Check repository state</command>
    <command>git log - Review recent commit message style</command>
    <command>git add - Stage files for commit</command>
    <command>git commit - Create commits</command>
  </allowed_git_commands>
  <forbidden_git_commands>
    <command>git push - Do not push unless user explicitly requests</command>
    <command>git commit --amend - Do not amend unless user explicitly requests</command>
    <command>git reset --hard - Never use destructive commands</command>
    <command>git rebase -i - Do not use interactive commands</command>
  </forbidden_git_commands>
</tool_restrictions>

<rules>
  <rule priority="critical">Run git diff HEAD to analyze all changes before creating commit message</rule>
  <rule priority="critical">Select correct semantic prefix based on change type - fix: for bug fixes, feat: for new features/enhancements, chore: for documentation/maintenance</rule>
  <rule priority="critical">Do NOT include "Generated with [Claude Code]" footer in commit messages</rule>
  <rule priority="high">Keep summary line under 50 characters including prefix</rule>
  <rule priority="high">Include detailed description as bulleted list with affected components/files</rule>
  <rule priority="high">Use present tense in commit messages</rule>
  <rule priority="medium">Explain what and why, not how</rule>
  <rule priority="medium">Review recent git log to maintain style consistency with project</rule>
  <rule priority="medium">Stage relevant files with git add before committing</rule>
  <rule priority="high">After successful commit, inform user if they have commits to push to remote</rule>
  <rule priority="critical">NEVER auto-push commits - only inform user when they have unpushed commits</rule>
</rules>

<research>
  <step name="analyze_changes">
    <action>Run git diff HEAD to see all changes (staged and unstaged)</action>
    <purpose>Understand scope and nature of modifications</purpose>
  </step>
  <step name="check_status">
    <action>Run git status to see which files are modified/added/deleted</action>
    <purpose>Identify all affected files</purpose>
  </step>
  <step name="review_history">
    <action>Run git log --oneline -10 to see recent commit message style</action>
    <purpose>Maintain consistency with project commit conventions</purpose>
  </step>
  <step name="classify_changes">
    <question>Are changes fixing existing functionality (fix:)?</question>
    <question>Are changes adding new features or enhancements (feat:)?</question>
    <question>Are changes only documentation or maintenance (chore:)?</question>
  </step>
</research>

<validation>
  <check>Verify summary line is under 50 characters including prefix</check>
  <check>Confirm prefix (fix:/feat:/chore:) matches the nature of changes</check>
  <check>Ensure detailed description lists affected components or files</check>
  <check>Verify commit message uses present tense</check>
  <check>Confirm no Claude Code footer is included</check>
</validation>

<constraints>
  <constraint>Do not include "Generated with [Claude Code]" or similar footers</constraint>
  <constraint>Do not create empty commits if no changes detected</constraint>
  <constraint>Do not push to remote unless explicitly requested by user</constraint>
  <constraint>Do not amend commits unless explicitly requested by user</constraint>
  <constraint>Summary line must be under 50 characters</constraint>
</constraints>

<prefix_selection>
  <prefix name="fix:">
    <when>Correcting bugs or issues in existing functionality</when>
    <when>Fixing broken features or behavior</when>
    <when>Resolving errors or defects</when>
    <example>fix: Correct token validation in login</example>
  </prefix>
  <prefix name="feat:">
    <when>Adding new features or components</when>
    <when>Enhancing existing functionality with new capabilities</when>
    <when>Introducing new code or behavior</when>
    <example>feat: Add dark mode toggle to settings</example>
  </prefix>
  <prefix name="chore:">
    <when>Updating documentation</when>
    <when>Managing dependencies or package versions</when>
    <when>Performing maintenance tasks</when>
    <when>Refactoring without changing behavior</when>
    <example>chore: Update README with setup instructions</example>
  </prefix>
</prefix_selection>

<commit_message_format>
  <structure>
    <summary>
      [prefix]: [imperative description under 50 chars total]
    </summary>
    <blank_line />
    <detailed_description>
      - [Bullet point describing change and affected component]
      - [Additional bullet points as needed]
      - [Always mention affected files or components]
    </detailed_description>
  </structure>
  <style>
    <guideline>Use present tense imperative mood (Add, Fix, Update, not Added, Fixed, Updated)</guideline>
    <guideline>Explain what and why, not implementation details</guideline>
    <guideline>Be specific about affected components or files</guideline>
    <guideline>Keep summary focused on single main change</guideline>
  </style>
</commit_message_format>

<workflow>
  <step name="analyze">
    <action>Run git diff HEAD to see all changes</action>
    <action>Run git status to check file states</action>
    <action>Optionally run git log to review project style</action>
  </step>
  <step name="classify">
    <action>Determine change type (fix/feat/chore)</action>
    <action>Identify affected components and files</action>
  </step>
  <step name="compose">
    <action>Write summary line with correct prefix (under 50 chars)</action>
    <action>Write detailed description with bulleted list</action>
    <action>Include affected components/files</action>
  </step>
  <step name="stage">
    <action>Stage relevant files with git add if not already staged</action>
  </step>
  <step name="commit">
    <action>Create commit using git commit with composed message</action>
    <action>Use heredoc format for proper message formatting</action>
  </step>
  <step name="notify">
    <action>After successful commit, check if there are unpushed commits</action>
    <action>Inform user they have commits ready to push (do NOT auto-push)</action>
  </step>
</workflow>

<examples>
  <example name="bug_fix_commit">
    <scenario>Fixed authentication token validation issue</scenario>
    <git_diff>
      Modified: src/auth/login.ts
      - Fixed token expiration check logic
      - Updated validation function
    </git_diff>
    <commit_message>
      fix: Correct token validation in login

      - Fixed token expiration check in auth/login.ts
      - Updated validateToken function logic
      - Affected components: authentication module
    </commit_message>
    <prefix_rationale>Used "fix:" because changes correct existing broken functionality</prefix_rationale>
  </example>

  <example name="new_feature_commit">
    <scenario>Added dark mode support to application</scenario>
    <git_diff>
      Added: src/components/DarkModeToggle.tsx
      Modified: src/App.tsx
      Modified: src/styles/theme.ts
    </git_diff>
    <commit_message>
      feat: Add dark mode toggle to settings

      - Created DarkModeToggle component
      - Integrated toggle into App.tsx settings
      - Updated theme.ts with dark mode colors
      - Affected components: UI settings, theme system
    </commit_message>
    <prefix_rationale>Used "feat:" because changes introduce new functionality</prefix_rationale>
  </example>

  <example name="documentation_commit">
    <scenario>Updated project documentation</scenario>
    <git_diff>
      Modified: README.md
      Added: docs/setup-guide.md
      Modified: docs/api-reference.md
    </git_diff>
    <commit_message>
      chore: Update documentation for setup process

      - Enhanced README.md with quick start guide
      - Added detailed setup-guide.md
      - Updated api-reference.md with new endpoints
      - Affected files: documentation
    </commit_message>
    <prefix_rationale>Used "chore:" because changes only affect documentation, not code functionality</prefix_rationale>
  </example>

  <example name="multiple_file_enhancement">
    <scenario>Improved error handling across API endpoints</scenario>
    <git_diff>
      Modified: src/api/users.ts
      Modified: src/api/auth.ts
      Modified: src/middleware/errorHandler.ts
    </git_diff>
    <commit_message>
      feat: Improve error handling in API endpoints

      - Enhanced error handling in users.ts and auth.ts
      - Updated errorHandler middleware with new patterns
      - Added detailed error messages for API failures
      - Affected components: API layer, middleware
    </commit_message>
    <prefix_rationale>Used "feat:" because changes enhance existing functionality with new error handling capabilities</prefix_rationale>
  </example>
</examples>

<error_handling>
  <scenario type="no_changes">
    <condition>git diff HEAD returns empty</condition>
    <action>Inform user no changes detected, do not create commit</action>
  </scenario>
  <scenario type="commit_fails">
    <condition>git commit command fails (hooks, conflicts, etc.)</condition>
    <action>Report error details to user, do not retry automatically</action>
  </scenario>
  <scenario type="ambiguous_classification">
    <condition>Changes span multiple types (fix + feat)</condition>
    <action>Choose primary change type or ask user for clarification</action>
  </scenario>
  <scenario type="very_large_diff">
    <condition>git diff output is extremely large</condition>
    <action>Summarize major changes, group by component or file type</action>
  </scenario>
</error_handling>

<related_skills>
  <skill name="storyline-develop">Automatically invokes this skill after implementing specs to commit changes</skill>
  <skill name="create-plans">May be invoked after plan execution to commit completed work</skill>
</related_skills>

</skill>
