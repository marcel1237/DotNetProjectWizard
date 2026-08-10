#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 01 - Bootstrap Framework
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"

LIB="$PROJECT_ROOT/lib"
LOG="$PROJECT_ROOT/logs"
CACHE="$PROJECT_ROOT/cache"
TMP="$PROJECT_ROOT/tmp"
BUILD="$PROJECT_ROOT/build"
OUTPUT="$PROJECT_ROOT/output"

mkdir -p "$LIB"
mkdir -p "$LOG"
mkdir -p "$CACHE"
mkdir -p "$TMP"
mkdir -p "$BUILD"
mkdir -p "$OUTPUT"

cat > "$LIB/common.sh" <<'COMMON'
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

COMMON

chmod +x "$LIB/common.sh"

cat > "$LIB/filesystem.sh" <<'FILESYSTEM'
#!/usr/bin/env bash

source "$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI/lib/common.sh"

create_gui_tree() {

ensure_dir "$PROJECT_ROOT/src"

ensure_dir "$PROJECT_ROOT/tests"

ensure_dir "$PROJECT_ROOT/assets"

ensure_dir "$PROJECT_ROOT/resources"

ensure_dir "$PROJECT_ROOT/themes"

ensure_dir "$PROJECT_ROOT/scripts"

ensure_dir "$PROJECT_ROOT/templates"

ensure_dir "$PROJECT_ROOT/config"

ensure_dir "$PROJECT_ROOT/logs"

ensure_dir "$PROJECT_ROOT/output"

ensure_dir "$PROJECT_ROOT/build"

ensure_dir "$PROJECT_ROOT/cache"

}

FILESYSTEM

chmod +x "$LIB/filesystem.sh"

cat > "$LIB/dotnet.sh" <<'DOTNET'
#!/usr/bin/env bash

source "$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI/lib/common.sh"

check_dotnet() {

require dotnet

}

sdk_version() {

dotnet --version

}

restore() {

dotnet restore

}

build() {

dotnet build

}

DOTNET

chmod +x "$LIB/dotnet.sh"

cat > "$LIB/avalonia.sh" <<'AVALONIA'
#!/usr/bin/env bash

source "$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI/lib/common.sh"

install_template() {

if ! dotnet new list | grep -qi Avalonia
then
    dotnet new install Avalonia.Templates
fi

}

AVALONIA

chmod +x "$LIB/avalonia.sh"

cat > "$LIB/logger.sh" <<'LOGGER'
#!/usr/bin/env bash

LOGFILE="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI/logs/wizard.log"

mkdir -p "$(dirname "$LOGFILE")"

touch "$LOGFILE"

write_log() {

echo "$(date +"%F %T") $1" >> "$LOGFILE"

}

LOGGER

chmod +x "$LIB/logger.sh"

cat > README-FIRST-STEPS.md <<README
DotNetProjectWizard GUI

Bootstrap criado com sucesso.

Bibliotecas instaladas:

common.sh

filesystem.sh

dotnet.sh

avalonia.sh

logger.sh

Os próximos scripts utilizarão estas bibliotecas.
README

echo
echo "========================================="
echo " Bootstrap criado com sucesso"
echo "========================================="
echo
echo "Bibliotecas:"
echo
echo " lib/common.sh"
echo " lib/filesystem.sh"
echo " lib/dotnet.sh"
echo " lib/avalonia.sh"
echo " lib/logger.sh"
echo
echo "Próximo:"
echo
echo "02-create-solution.sh"
echo
