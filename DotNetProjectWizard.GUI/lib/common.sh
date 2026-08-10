#!/usr/bin/env bash

set -Eeuo pipefail

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"

timestamp() {

date +"%Y-%m-%d %H:%M:%S"

}

log() {

echo -e "$(timestamp) $1"

}

info() {

echo -e "${BLUE}[INFO]${RESET} $1"

}

success() {

echo -e "${GREEN}[ OK ]${RESET} $1"

}

warning() {

echo -e "${YELLOW}[WARN]${RESET} $1"

}

error() {

echo -e "${RED}[ERRO]${RESET} $1"

}

die() {

error "$1"

exit 1

}

require() {

command -v "$1" >/dev/null 2>&1 || die "$1 não encontrado."

}

ensure_dir() {

mkdir -p "$1"

}

backup_file() {

local FILE="$1"

[[ -f "$FILE" ]] || return

mkdir -p "$PROJECT_ROOT/backup"

cp "$FILE" "$PROJECT_ROOT/backup/$(basename "$FILE").bak"

}

