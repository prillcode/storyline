@echo off
REM Storyline Windows Installer
REM Usage: Run this file from the cloned storyline repository

echo.
echo Installing Storyline for Windows...
echo.

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

REM Verify we're in the storyline repository
if not exist "skills" (
    echo Error: This script must be run from the storyline repository directory
    echo Please clone the repository first:
    echo   git clone https://github.com/prillcode/storyline.git
    echo   cd storyline
    echo   windows-install.cmd
    pause
    exit /b 1
)

echo Installing from: %SCRIPT_DIR%
echo.

REM Create .claude directories
if not exist "%USERPROFILE%\.claude\skills" mkdir "%USERPROFILE%\.claude\skills"
if not exist "%USERPROFILE%\.claude\commands" mkdir "%USERPROFILE%\.claude\commands"
if not exist "%USERPROFILE%\.claude\agents" mkdir "%USERPROFILE%\.claude\agents"

REM Install bundled cc-resources dependencies
if exist "cc-resources\skills" (
    echo Installing cc-resources dependencies...
    xcopy /E /I /Y /Q "cc-resources\skills\*" "%USERPROFILE%\.claude\skills\" >nul
    echo cc-resources installed successfully!
) else (
    echo Error: cc-resources directory not found
    echo The bundled dependencies are missing. This shouldn't happen.
    echo Please re-clone the repository or report this issue.
    pause
    exit /b 1
)

REM Install storyline skills and commands
echo Installing Storyline skills and commands...
xcopy /E /I /Y /Q "skills\*" "%USERPROFILE%\.claude\skills\" >nul
xcopy /E /I /Y /Q "commands\*" "%USERPROFILE%\.claude\commands\" >nul

echo.
echo ================================
echo Storyline v0.21.5 installed successfully!
echo ================================
echo.
echo Available sl-commands (story-led development):
echo   /sl-setup [command]            - Initialize, manage, check projects
echo   /sl-epic-creator [PRD.md]      - Create epics from PRD (or guided mode)
echo   /sl-story-creator ^<epic-file^>  - Generate user stories from epic
echo   /sl-spec-story ^<story-file^>    - Create technical spec from story
echo   /sl-develop ^<spec-file^>        - Execute technical spec (implement)
echo   /sl-commit [message]           - Create conventional commit (auto or manual)
echo.
echo Quick start:
echo   1. /sl-setup init                          # Initialize project
echo   2. /sl-epic-creator                        # Guided PRD creation
echo   3. /sl-story-creator .storyline/epics/epic-{id}-01.md
echo   4. /sl-spec-story .storyline/stories/epic-{id}-01/story-01.md
echo   5. /sl-develop .storyline/specs/epic-{id}-01/spec-01.md
echo   6. /sl-setup status                        # Check progress
echo.
echo Start a new Claude Code session and run: /sl-setup check
echo.
echo Documentation: https://github.com/prillcode/storyline
echo.
pause
