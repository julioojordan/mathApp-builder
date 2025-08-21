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