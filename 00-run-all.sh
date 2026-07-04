#!/usr/bin/env bash
#
# DotNetProjectWizard
# Master Installer
#

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

trap 'echo; echo "❌ Erro na linha $LINENO"; exit 1' ERR

echo
echo "==========================================="
echo "   DotNetProjectWizard - Master Installer"
echo "==========================================="
echo

shopt -s nullglob

FILES=()

for f in "$SCRIPT_DIR"/[0-9][0-9]-*.sh; do
    [[ "$(basename "$f")" == "00-run-all.sh" ]] && continue
    FILES+=("$f")
done

TOTAL=${#FILES[@]}

if [[ $TOTAL -eq 0 ]]; then
    echo "❌ Nenhuma shell script encontrada."
    exit 1
fi

COUNT=1
START_TIME=$(date +%s)

for SCRIPT in "${FILES[@]}"; do
    NAME=$(basename "$SCRIPT")

    echo
    echo "==========================================="
    echo "[$COUNT/$TOTAL] Executando: $NAME"
    echo "==========================================="

    chmod +x "$SCRIPT"

    STEP_START=$(date +%s)

    "$SCRIPT"

    STEP_END=$(date +%s)

    echo
    echo "✔ $NAME concluída em $((STEP_END - STEP_START)) segundos."

    ((COUNT++))
done

END_TIME=$(date +%s)

echo
echo "==========================================="
echo "✅ Todas as etapas foram executadas."
echo "⏱ Tempo total: $((END_TIME - START_TIME)) segundos."
echo "==========================================="
