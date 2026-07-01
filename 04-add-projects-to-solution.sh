#!/usr/bin/env bash

set -euo pipefail

########################################
# DotNet Project Wizard
# Step 04
# Add Projects To Solution
########################################

PROJECT_NAME="DotNetProjectWizard"

ROOT_DIR="$HOME/$PROJECT_NAME"

APP_PROJECT="$ROOT_DIR/src/$PROJECT_NAME/$PROJECT_NAME.csproj"
TEST_PROJECT="$ROOT_DIR/tests/$PROJECT_NAME.Tests/$PROJECT_NAME.Tests.csproj"

########################################
# Find Solution
########################################

find_solution() {

    if [ -f "$ROOT_DIR/$PROJECT_NAME.slnx" ]; then
        echo "$ROOT_DIR/$PROJECT_NAME.slnx"
        return
    fi

    if [ -f "$ROOT_DIR/$PROJECT_NAME.sln" ]; then
        echo "$ROOT_DIR/$PROJECT_NAME.sln"
        return
    fi

    echo ""
}

SOLUTION_FILE=$(find_solution)

########################################
# Validation
########################################

echo
echo "========================================="
echo " DotNet Project Wizard"
echo " Step 04 - Add Projects To Solution"
echo "========================================="
echo

if [ -z "$SOLUTION_FILE" ]; then
    echo "ERROR:"
    echo "Solution file not found."
    echo
    echo "Expected:"
    echo "  $ROOT_DIR/$PROJECT_NAME.slnx"
    echo "or"
    echo "  $ROOT_DIR/$PROJECT_NAME.sln"
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
# Add Projects
########################################

cd "$ROOT_DIR"

echo "[1/2] Adding application project..."

dotnet sln "$SOLUTION_FILE" add "$APP_PROJECT"

echo

echo "[2/2] Adding test project..."

dotnet sln "$SOLUTION_FILE" add "$TEST_PROJECT"

########################################
# Result
########################################

echo
echo "========================================="
echo " Projects added successfully!"
echo "========================================="
echo

echo "Solution:"
echo "  $SOLUTION_FILE"
echo

echo "Projects:"

dotnet sln "$SOLUTION_FILE" list

echo

