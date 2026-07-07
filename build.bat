@echo off
setlocal

:: REMEMBER: bump --app-version below (2 places) to match the git tag before each release build
set APP_VERSION=1.1.0

set PROJECT_DIR=%~dp0
set RESHACKER="C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe"

if not exist %RESHACKER% (
    echo [ERROR] Resource Hacker not found at %RESHACKER%
    echo Download it free from https://www.angusj.com/resourcehacker/ and install it, then re-run this script.
    exit /b 1
)

echo === Cleaning old build ===
rmdir /s /q "%PROJECT_DIR%dist" 2>nul
rmdir /s /q "%PROJECT_DIR%installer" 2>nul

echo === Step 1: Building app-image (v%APP_VERSION%) ===
jpackage --type app-image --name "ReplayGlitch" --app-version %APP_VERSION% --input "%PROJECT_DIR%target" --main-jar ReplayGlitch-1.0-SNAPSHOT.jar --main-class com.tymon.replayglitch.Launcher --dest "%PROJECT_DIR%dist" --module-path "%PROJECT_DIR%target\libs" --add-modules javafx.controls,javafx.fxml

if not exist "%PROJECT_DIR%dist\ReplayGlitch\ReplayGlitch.exe" (
    echo [ERROR] jpackage app-image build failed. Stopping.
    exit /b 1
)

echo === Step 2: Embedding UAC manifest into app-image exe ===
%RESHACKER% -open "%PROJECT_DIR%dist\ReplayGlitch\ReplayGlitch.exe" -save "%PROJECT_DIR%dist\ReplayGlitch\ReplayGlitch.exe" -action addoverwrite -res "%PROJECT_DIR%app.manifest" -mask MANIFEST,1,1033

echo === Step 3: Building installer from patched app-image (v%APP_VERSION%) ===
jpackage --type exe --name "ReplayGlitch" --app-version %APP_VERSION% --app-image "%PROJECT_DIR%dist\ReplayGlitch" --dest "%PROJECT_DIR%installer" --win-menu --win-shortcut --win-dir-chooser --win-upgrade-uuid 3f9a1d2c-6b4e-4a0f-9c2a-1e7f5d8b0a11

if not exist "%PROJECT_DIR%installer" (
    echo [ERROR] Installer build failed. Stopping.
    exit /b 1
)

echo === Build complete: v%APP_VERSION% installer in installer\ ===
endlocal