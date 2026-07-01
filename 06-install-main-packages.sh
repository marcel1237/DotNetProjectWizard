#!/usr/bin/env bash

set -euo pipefail

########################################
# DotNet Project Wizard
# Step 06
# Install Main Packages
########################################

PROJECT_NAME="DotNetProjectWizard"

ROOT_DIR="$HOME/$PROJECT_NAME"

APP_PROJECT="$ROOT_DIR/src/$PROJECT_NAME/$PROJECT_NAME.csproj"

echo
echo "========================================="
echo " DotNet Project Wizard"
echo " Step 06 - Install Main Packages"
echo "========================================="
echo

if [ ! -f "$APP_PROJECT" ]; then
    echo "ERROR:"
    echo "Application project not found:"
    echo "  $APP_PROJECT"
    exit 1
fi

echo "[1/2] Installing System.CommandLine..."

dotnet add "$APP_PROJECT" package System.CommandLine

echo

echo "[2/2] Installing Spectre.Console..."

dotnet add "$APP_PROJECT" package Spectre.Console

echo

echo "========================================="
echo " Packages installed successfully!"
echo "========================================="
echo

echo "Installed packages:"
echo

dotnet list "$APP_PROJECT" package

echo

