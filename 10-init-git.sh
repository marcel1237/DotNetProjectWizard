#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="DotNetProjectWizard"
ROOT_DIR="$HOME/$PROJECT_NAME"

cd "$ROOT_DIR"

echo "Initializing git..."

git init

cat > .gitignore <<'GIT'
bin/
obj/
.vs/
*.user
*.log
GIT

git add .
git commit -m "Initial commit - DotNetProjectWizard CLI base"

echo "Git initialized."
