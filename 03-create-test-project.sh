#!/usr/bin/env bash

set -euo pipefail

########################################
# DotNet Project Wizard
# Step 03
# Create Test Project
########################################

PROJECT_NAME="DotNetProjectWizard"
TEST_PROJECT="${PROJECT_NAME}.Tests"
ROOT_DIR="$HOME/$PROJECT_NAME"

echo
echo "========================================="
echo " DotNet Project Wizard"
echo " Step 03 - Create Test Project"
echo "========================================="
echo

if [ ! -d "$ROOT_DIR" ]; then
    echo "ERROR:"
    echo "Project not found."
    echo
    echo "Run Step 01 first."
    exit 1
fi

cd "$ROOT_DIR"

echo "[1/2] Creating test project..."

dotnet new xunit \
    --name "$TEST_PROJECT" \
    --output "tests/$TEST_PROJECT"

echo "[2/2] Test project created."

echo
echo "========================================="
echo " Test project created successfully!"
echo "========================================="
echo
echo "Location:"
echo "  $ROOT_DIR/tests/$TEST_PROJECT"
echo

