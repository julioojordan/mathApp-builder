#!/bin/bash

FE_REPO="https://github.com/julioojordan/mathApp.git"
BE_REPO="https://github.com/julioojordan/mathApp-service.git"

echo "Deleting Old Folder..."
rm -rf mathApp mathApp-service
echo "Harap menunggu"

echo "Cloning repo frontend ($FE_REPO)..."
git clone $FE_REPO mathApp

echo "Cloning repo backend ($BE_REPO)..."
git clone $BE_REPO mathApp-service

echo "Repository Updated Successfully!"
