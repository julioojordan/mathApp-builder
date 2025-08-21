@echo off
setlocal

REM -------------------------
REM Setup Script - setup.bat
REM -------------------------

REM Step 1: Remove existing folder if it exists
if exist mathApp-builder (
    echo.
    echo [🗑️ ] Removing existing 'mathApp-builder' directory...
    rmdir /s /q mathApp-builder
)

REM Step 2: Clone the repository
echo.
echo [⬇️ ] Cloning repository from GitHub...
git clone https://github.com/julioojordan/mathApp-builder.git

REM Step 3: Enter project directory
cd mathApp-builder || (
    echo [❌] Failed to enter 'mathApp-builder' directory.
    pause
    exit /b 1
)

REM Step 4: Run PowerShell script
echo.
echo [⚙️ ] Running run.ps1 script...
powershell.exe -ExecutionPolicy Bypass -File ./run.ps1

echo.
echo [✅] Setup finished.
pause
endlocal
