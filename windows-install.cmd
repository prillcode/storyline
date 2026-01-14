@echo off
REM Storyline Windows Installer
REM Usage: Download and run this file, or run directly from command prompt

echo.
echo Installing Storyline for Windows...
echo.

REM Check if git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: git is not installed
    echo Please install git first: https://git-scm.com/downloads
    pause
    exit /b 1
)

REM Set installation directory
if "%STORYLINE_INSTALL_DIR%"=="" (
    set "INSTALL_DIR=%USERPROFILE%\.local\share\storyline"
) else (
    set "INSTALL_DIR=%STORYLINE_INSTALL_DIR%"
)

echo Installation directory: %INSTALL_DIR%
echo.

REM Check if already installed
if exist "%INSTALL_DIR%\.git" (
    echo Storyline already installed. Updating...
    cd /d "%INSTALL_DIR%"
    git reset --hard HEAD
    git clean -fd
    git pull origin main
    git submodule update --init --recursive
) else (
    echo Cloning Storyline repository...
    git clone --recurse-submodules https://github.com/prillcode/storyline.git "%INSTALL_DIR%"
)

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error: Failed to clone/update repository
    pause
    exit /b 1
)

echo.
echo Repository ready!
echo.

REM Create .claude directories
if not exist "%USERPROFILE%\.claude\skills" mkdir "%USERPROFILE%\.claude\skills"
if not exist "%USERPROFILE%\.claude\commands" mkdir "%USERPROFILE%\.claude\commands"
if not exist "%USERPROFILE%\.claude\agents" mkdir "%USERPROFILE%\.claude\agents"

REM Install cc-resources dependencies
if exist "%INSTALL_DIR%\dependencies\cc-resources\skills" (
    echo Installing cc-resources dependencies...
    xcopy /E /I /Y /Q "%INSTALL_DIR%\dependencies\cc-resources\skills\*" "%USERPROFILE%\.claude\skills\" >nul
    xcopy /E /I /Y /Q "%INSTALL_DIR%\dependencies\cc-resources\commands\*" "%USERPROFILE%\.claude\commands\" >nul
    if exist "%INSTALL_DIR%\dependencies\cc-resources\agents" (
        xcopy /E /I /Y /Q "%INSTALL_DIR%\dependencies\cc-resources\agents\*" "%USERPROFILE%\.claude\agents\" >nul
    )
    echo cc-resources installed successfully!
) else (
    echo Warning: cc-resources dependencies not found
    echo The submodule may not have been initialized correctly
)

REM Install storyline skills and commands
echo Installing Storyline skills and commands...
xcopy /E /I /Y /Q "%INSTALL_DIR%\skills\*" "%USERPROFILE%\.claude\skills\" >nul
xcopy /E /I /Y /Q "%INSTALL_DIR%\commands\*" "%USERPROFILE%\.claude\commands\" >nul

echo.
echo ================================
echo Storyline v2.1.3 installed successfully!
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
