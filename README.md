# mathApp-builder
Build Math App with single command

## One-Click App Installer

This repository contains a self-contained "one-click" solution to set up and run the **mathApp** application using Docker. It supports both Windows and macOS/Linux environments with minimal setup.

---

## Prerequisites !!!

- **git** installed and available on your PATH
- **Windows**: PowerShell (for `.bat` script)
- **macOS/Linux**: Bash (for `.sh` script)
- **Docker** installed and running

---

## Usage

### Windows (Batch Script)

1. Create a file named `setup.bat` with the following content or just copy the setup.bat:
   ```bat
   @echo off
   REM Remove existing folder if any
   if exist mathApp-builder (
       echo Removing existing mathApp-builder directory...
       rmdir /s /q mathApp-builder
   )

   REM Clone repository
   echo Cloning repository...
   git clone https://github.com/julioojordan/mathApp-builder.git

   REM Enter project directory
   cd mathApp-builder || exit

   REM Run the PowerShell setup script
   echo Running run.ps1...
   powershell.exe -ExecutionPolicy Bypass -File ./run.ps1

   pause
   ```
2. Double-click `setup.bat` to execute the setup and launch the application., maybe process took too long because your internet when downloading image in docker

---

### macOS / Linux (Shell Script)

1. Create a file named `setup.sh` with the following content or copy the setup.bat from this repo to your local and give it execute permission:
   ```bash
   #!/usr/bin/env bash

   # Remove existing folder if any
   if [ -d "mathApp-builder" ]; then
     echo "Removing existing mathApp-builder directory..."
     rm -rf mathApp-builder
   fi

   # Clone repository
   echo "Cloning repository..."
   git clone https://github.com/julioojordan/mathApp-builder.git

   # Enter project directory
   cd mathApp-builder || exit

   # Run the setup script (POSIX shell version)
   echo "Running run.sh..."
   bash ./run.sh
   ```
2. after you got the setup.sh Make the script executable and run it:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

---

## What It Does

- **Removes** any previous `mathApp-builder` folder
- **Clones** the latest code from GitHub
- **Executes** the platform-specific setup script (`run.ps1` on Windows, `run.sh` on macOS/Linux)
- **Launches** the Docker-based application with a single command

Enjoy your one-click setup! 🎉

