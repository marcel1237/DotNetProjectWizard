#!/usr/bin/env bash
#
# ============================================================================
# DotNetProjectWizard
#
# Patch 001
#
# Alpha Build Auditor
#
# Versão: Alpha 0.1.0
# ============================================================================
#

set -Eeuo pipefail

PATCH_ID="001-alpha-build"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/audit.sh"

################################################################################
# HEADER
################################################################################

clear

echo
echo "============================================================"
echo "            DotNetProjectWizard Patch System"
echo "============================================================"
echo
echo " Patch........: $PATCH_ID"
echo " Version......: $PATCH_VERSION"
echo " Date.........: $PATCH_DATE"
echo
echo "============================================================"
echo

################################################################################
# INITIALIZATION
################################################################################

section "Inicialização"

ensure_patch_dirs

create_history

################################################################################
# ALREADY APPLIED?
################################################################################

if patch_applied "$PATCH_ID"
then

    warn "Este patch já foi executado."

    read -rp "Executar novamente? [y/N] " answer

    case "$answer" in

        y|Y|yes|YES)
            ;;
        *)
            echo
            info "Encerrando."
            exit 0
            ;;
    esac

fi

################################################################################
# REQUIREMENTS
################################################################################

section "Verificando Ambiente"

require_command dotnet
require_command git
require_command find
require_command grep
require_command sed

echo

info "SDK instalado:"

dotnet_version

echo

################################################################################
# PROJECT
################################################################################

section "Projeto"

require_project

################################################################################
# BACKUP
################################################################################

section "Backup"

start_backup

################################################################################
# REPORT
################################################################################

section "Relatório"

start_report

report "# Patch"
report ""
report "$PATCH_ID"
report ""

################################################################################
# AUDIT
################################################################################

section "Auditoria"

run_audit

################################################################################
# BUILD
################################################################################

section "Restore"

if run_restore
then

    ok "Restore concluído."

    report "- Restore: OK"

else

    error "Restore falhou."

    report "- Restore: FAILED"

fi

echo

section "Build"

if run_build
then

    ok "Build concluído."

    report "- Build: OK"

else

    error "Build falhou."

    report "- Build: FAILED"

fi

################################################################################
# REGISTER
################################################################################

register_patch "$PATCH_ID"

################################################################################
# FOOTER
################################################################################

finish

echo

echo "============================================================"

echo " Auditoria concluída."

echo

echo " Relatório"

echo "   $REPORT_FILE"

echo

echo " Histórico"

echo "   $PATCH_HISTORY"

echo

echo " Backup"

echo "   $BACKUP_DIR"

echo

echo "============================================================"

echo

if [[ -f "$REPORT_FILE" ]]
then

    info "Resumo:"

    echo

    tail -20 "$REPORT_FILE"

fi

echo

echo "============================================================"

echo " Fim."

echo "============================================================"

echo
