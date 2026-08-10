#!/usr/bin/env bash
#
# ================================================================
# DotNetProjectWizard Patch System
# Common Library
# Alpha 0.1.0
# ================================================================
#

set -Eeuo pipefail

PATCH_VERSION="Alpha 0.1.0"
PATCH_DATE="$(date '+%Y-%m-%d %H:%M:%S')"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

PATCH_DIR="$PROJECT_ROOT/patches"
PATCH_LIB="$PATCH_DIR/lib"
PATCH_LOGS="$PATCH_DIR/logs"
PATCH_REPORTS="$PATCH_DIR/reports"
PATCH_BACKUPS="$PATCH_DIR/backups"

PATCH_HISTORY="$PROJECT_ROOT/.patch_history"

REPORT_FILE="$PATCH_REPORTS/AlphaBuildReport.md"

################################################################################
# COLORS
################################################################################

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
RESET='\033[0m'

################################################################################
# OUTPUT
################################################################################

info() {
    echo -e "${BLUE}[INFO]${RESET} $*"
}

ok() {
    echo -e "${GREEN}[ OK ]${RESET} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${RESET} $*"
}

error() {
    echo -e "${RED}[FAIL]${RESET} $*"
}

section() {

    echo
    echo "====================================================="
    echo "$1"
    echo "====================================================="
    echo
}

################################################################################
# DIRECTORY SETUP
################################################################################

ensure_patch_dirs() {

    mkdir -p "$PATCH_DIR"
    mkdir -p "$PATCH_LIB"
    mkdir -p "$PATCH_LOGS"
    mkdir -p "$PATCH_REPORTS"
    mkdir -p "$PATCH_BACKUPS"

}

################################################################################
# HISTORY
################################################################################

history_exists() {

    [[ -f "$PATCH_HISTORY" ]]

}

create_history() {

    if ! history_exists; then

        touch "$PATCH_HISTORY"

    fi

}

patch_applied() {

    local patch="$1"

    grep -qx "$patch" "$PATCH_HISTORY" 2>/dev/null

}

register_patch() {

    local patch="$1"

    if ! patch_applied "$patch"; then

        echo "$patch" >> "$PATCH_HISTORY"

    fi

}

################################################################################
# BACKUP
################################################################################

BACKUP_DIR=""

start_backup() {

    local stamp

    stamp=$(date '+%Y%m%d_%H%M%S')

    BACKUP_DIR="$PATCH_BACKUPS/$stamp"

    mkdir -p "$BACKUP_DIR"

    ok "Backup criado:"

    echo "    $BACKUP_DIR"

}

backup_file() {

    local file="$1"

    if [[ -f "$file" ]]; then

        local rel

        rel="${file#$PROJECT_ROOT/}"

        mkdir -p "$BACKUP_DIR/$(dirname "$rel")"

        cp "$file" "$BACKUP_DIR/$rel"

    fi

}

################################################################################
# REPORT
################################################################################

start_report() {

cat > "$REPORT_FILE" <<REPORT
# DotNetProjectWizard

## Alpha Build Report

Data:

$PATCH_DATE

Versão:

$PATCH_VERSION

---

REPORT

}

report() {

    echo "$*" >> "$REPORT_FILE"

}

################################################################################
# REQUIREMENTS
################################################################################

require_command() {

    local cmd="$1"

    if command -v "$cmd" >/dev/null 2>&1; then

        ok "$cmd encontrado."

    else

        error "$cmd não encontrado."

        exit 1

    fi

}

################################################################################
# DOTNET
################################################################################

dotnet_version() {

    dotnet --version

}

################################################################################
# PROJECT
################################################################################

require_project() {

    if [[ ! -f "$PROJECT_ROOT/DotNetProjectWizard.GUI.slnx" ]]; then

        error "Solution não encontrada."

        exit 1

    fi

    ok "Solution encontrada."

}

################################################################################
# BUILD
################################################################################

run_restore() {

    section "dotnet restore"

    dotnet restore

}

run_build() {

    section "dotnet build"

    dotnet build

}

################################################################################
# SUMMARY
################################################################################

finish() {

    echo
    echo "====================================================="
    echo "PATCH FINALIZADO"
    echo "====================================================="
    echo

    echo "Projeto : $PROJECT_ROOT"

    echo "Relatório : $REPORT_FILE"

    echo "Backup : $BACKUP_DIR"

    echo

}
