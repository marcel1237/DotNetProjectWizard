#!/usr/bin/env bash

set -euo pipefail

########################################
# DotNet Project Wizard
# Step 01
########################################

PROJECT_NAME="DotNetProjectWizard"
ROOT_DIR="$HOME/$PROJECT_NAME"

echo
echo "========================================="
echo " DotNet Project Wizard"
echo " Step 01 - Create Solution"
echo "========================================="
echo

echo "[1/4] Creating project directory..."
mkdir -p "$ROOT_DIR"

cd "$ROOT_DIR"

echo "[2/4] Creating solution..."
dotnet new sln \
    --name "$PROJECT_NAME"

echo "[3/4] Creating console project..."
dotnet new console \
    --name "$PROJECT_NAME" \
    --output "src/$PROJECT_NAME"

echo "[4/4] Adding project to solution..."
dotnet sln add \
    "src/$PROJECT_NAME/$PROJECT_NAME.csproj"

echo
echo "========================================="
echo " Project created successfully!"
echo "========================================="
echo
echo "Location:"
echo "  $ROOT_DIR"
echo
