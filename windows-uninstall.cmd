@echo off
REM Storyline Windows Uninstaller
REM https://github.com/prillcode/storyline

echo.
echo Storyline Uninstaller
echo.

REM Confirm uninstallation
echo This will remove all Storyline skills and commands from %USERPROFILE%\.claude\
set /p "response=Do you want to continue? (y/n): "

if /i not "%response%"=="y" if /i not "%response%"=="yes" (
    echo Uninstall cancelled.
    pause
    exit /b 0
)

echo.
echo Removing Storyline components...

REM Define base paths
set "SKILLS_DIR=%USERPROFILE%\.claude\skills"
set "COMMANDS_DIR=%USERPROFILE%\.claude\commands"

REM Remove skills (both old and new naming)
if exist "%SKILLS_DIR%\storyline-epic-creator" rmdir /s /q "%SKILLS_DIR%\storyline-epic-creator" 2>nul
if exist "%SKILLS_DIR%\storyline-story-creator" rmdir /s /q "%SKILLS_DIR%\storyline-story-creator" 2>nul
if exist "%SKILLS_DIR%\storyline-spec-story" rmdir /s /q "%SKILLS_DIR%\storyline-spec-story" 2>nul
if exist "%SKILLS_DIR%\storyline-dev-story" rmdir /s /q "%SKILLS_DIR%\storyline-dev-story" 2>nul
if exist "%SKILLS_DIR%\storyline-develop" rmdir /s /q "%SKILLS_DIR%\storyline-develop" 2>nul
if exist "%SKILLS_DIR%\storyline-setup" rmdir /s /q "%SKILLS_DIR%\storyline-setup" 2>nul

REM Remove old skill names (if they exist from previous installation)
if exist "%SKILLS_DIR%\epic-creator" rmdir /s /q "%SKILLS_DIR%\epic-creator" 2>nul
if exist "%SKILLS_DIR%\story-creator" rmdir /s /q "%SKILLS_DIR%\story-creator" 2>nul
if exist "%SKILLS_DIR%\spec-story" rmdir /s /q "%SKILLS_DIR%\spec-story" 2>nul
if exist "%SKILLS_DIR%\dev-story" rmdir /s /q "%SKILLS_DIR%\dev-story" 2>nul
if exist "%SKILLS_DIR%\develop" rmdir /s /q "%SKILLS_DIR%\develop" 2>nul

REM Remove commands (both old and new naming)
if exist "%COMMANDS_DIR%\sl-epic-creator.md" del /q "%COMMANDS_DIR%\sl-epic-creator.md" 2>nul
if exist "%COMMANDS_DIR%\sl-story-creator.md" del /q "%COMMANDS_DIR%\sl-story-creator.md" 2>nul
if exist "%COMMANDS_DIR%\sl-spec-story.md" del /q "%COMMANDS_DIR%\sl-spec-story.md" 2>nul
if exist "%COMMANDS_DIR%\sl-dev-story.md" del /q "%COMMANDS_DIR%\sl-dev-story.md" 2>nul
if exist "%COMMANDS_DIR%\sl-develop.md" del /q "%COMMANDS_DIR%\sl-develop.md" 2>nul
if exist "%COMMANDS_DIR%\sl-setup.md" del /q "%COMMANDS_DIR%\sl-setup.md" 2>nul

REM Remove old command names (if they exist from previous installation)
if exist "%COMMANDS_DIR%\epic-creator.md" del /q "%COMMANDS_DIR%\epic-creator.md" 2>nul
if exist "%COMMANDS_DIR%\story-creator.md" del /q "%COMMANDS_DIR%\story-creator.md" 2>nul
if exist "%COMMANDS_DIR%\spec-story.md" del /q "%COMMANDS_DIR%\spec-story.md" 2>nul
if exist "%COMMANDS_DIR%\dev-story.md" del /q "%COMMANDS_DIR%\dev-story.md" 2>nul
if exist "%COMMANDS_DIR%\develop.md" del /q "%COMMANDS_DIR%\develop.md" 2>nul

echo Storyline skills and commands removed
echo.

REM Ask about removing the cloned repository
set "REPO_PATH=%USERPROFILE%\.local\share\storyline"
if exist "%REPO_PATH%" (
    echo.
    set /p "response=Remove cloned repository at %REPO_PATH%? (y/n): "

    if /i "%response%"=="y" (
        rmdir /s /q "%REPO_PATH%"
        echo Repository removed
    ) else if /i "%response%"=="yes" (
        rmdir /s /q "%REPO_PATH%"
        echo Repository removed
    ) else (
        echo Repository kept at %REPO_PATH%
    )
)

echo.
echo ================================
echo Storyline uninstalled successfully!
echo ================================
echo.
echo Note: This does not remove cc-resources dependencies.
echo If you want to remove those as well, manually delete:
echo   %USERPROFILE%\.claude\skills\create-plans
echo   %USERPROFILE%\.claude\skills\create-agent-skills
echo   %USERPROFILE%\.claude\skills\create-meta-prompts
echo   (and other cc-resources skills/commands)
echo.
pause
