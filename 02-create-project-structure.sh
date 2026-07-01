#!/usr/bin/env bash

set -euo pipefail

########################################
# DotNet Project Wizard
# Step 02
# Create Project Structure
########################################

PROJECT_NAME="DotNetProjectWizard"
ROOT_DIR="$HOME/$PROJECT_NAME"

echo
echo "========================================="
echo " DotNet Project Wizard"
echo " Step 02 - Create Project Structure"
echo "========================================="
echo

if [ ! -d "$ROOT_DIR" ]; then
    echo "ERROR:"
    echo "Project not found:"
    echo "  $ROOT_DIR"
    echo
    echo "Run Step 01 first."
    exit 1
fi

echo "[1/8] Creating docs..."
mkdir -p "$ROOT_DIR/docs"

echo "[2/8] Creating scripts..."
mkdir -p "$ROOT_DIR/scripts"

echo "[3/8] Creating common scripts..."
mkdir -p "$ROOT_DIR/scripts/common"

echo "[4/8] Creating project templates..."
mkdir -p "$ROOT_DIR/scripts/api-rest"
mkdir -p "$ROOT_DIR/scripts/ecommerce"
mkdir -p "$ROOT_DIR/scripts/clean-architecture"
mkdir -p "$ROOT_DIR/scripts/microservices"
mkdir -p "$ROOT_DIR/scripts/modular-monolith"

echo "[5/8] Creating templates folder..."
mkdir -p "$ROOT_DIR/templates"

echo "[6/8] Creating tests folder..."
mkdir -p "$ROOT_DIR/tests"

echo "[7/8] Creating source folders..."
mkdir -p "$ROOT_DIR/src/$PROJECT_NAME/Commands"
mkdir -p "$ROOT_DIR/src/$PROJECT_NAME/Services"
mkdir -p "$ROOT_DIR/src/$PROJECT_NAME/Models"
mkdir -p "$ROOT_DIR/src/$PROJECT_NAME/Infrastructure"
mkdir -p "$ROOT_DIR/src/$PROJECT_NAME/Shell"
mkdir -p "$ROOT_DIR/src/$PROJECT_NAME/Utils"

echo "[8/8] Creating examples folder..."
mkdir -p "$ROOT_DIR/examples"

echo
echo "========================================="
echo " Project structure created successfully!"
echo "========================================="
echo
echo "Location:"
echo "  $ROOT_DIR"
echo
