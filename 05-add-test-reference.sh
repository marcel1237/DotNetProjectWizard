#!/usr/bin/env bash

set -euo pipefail

########################################
# DotNet Project Wizard
# Step 05
# Add Test Project Reference
########################################

PROJECT_NAME="DotNetProjectWizard"

ROOT_DIR="$HOME/$PROJECT_NAME"

APP_PROJECT="$ROOT_DIR/src/$PROJECT_NAME/$PROJECT_NAME.csproj"
TEST_PROJECT="$ROOT_DIR/tests/$PROJECT_NAME.Tests/$PROJECT_NAME.Tests.csproj"

########################################
# Find Solution
########################################

SOLUTION_FILE=""

if [ -f "$ROOT_DIR/$PROJECT_NAME.slnx" ]; then
    SOLUTION_FILE="$ROOT_DIR/$PROJECT_NAME.slnx"
elif [ -f "$ROOT_DIR/$PROJECT_NAME.sln" ]; then
    SOLUTION_FILE="$ROOT_DIR/$PROJECT_NAME.sln"
fi

########################################
# Validation
########################################

echo
echo "========================================="
echo " DotNet Project Wizard"
echo " Step 05 - Add Test Reference"
echo "========================================="
echo

if [ -z "$SOLUTION_FILE" ]; then
    echo "ERROR:"
    echo "Solution not found."
    exit 1
fi

if [ ! -f "$APP_PROJECT" ]; then
    echo "ERROR:"
    echo "Application project not found:"
    echo "  $APP_PROJECT"
    exit 1
fi

if [ ! -f "$TEST_PROJECT" ]; then
    echo "ERROR:"
    echo "Test project not found:"
    echo "  $TEST_PROJECT"
    exit 1
fi

########################################
# Add Reference
########################################

echo "Adding project reference..."

dotnet add "$TEST_PROJECT" reference "$APP_PROJECT"

echo
echo "========================================="
echo " Reference added successfully!"
echo "========================================="
echo

echo "Test Project:"
echo "  $TEST_PROJECT"

echo
echo "References:"
dotnet list "$TEST_PROJECT" reference

echo

