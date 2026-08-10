#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 02 - Create Solution + Avalonia Project (FIXED)
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/filesystem.sh"
source "$LIB/dotnet.sh"
source "$LIB/avalonia.sh"
source "$LIB/logger.sh"

APP_NAME="DotNetProjectWizard.App"
SRC_DIR="$PROJECT_ROOT/src"

info "Iniciando criação da Solution..."

cd "$PROJECT_ROOT"

require dotnet

info "Verificando SDK .NET..."
sdk_version
success "SDK encontrado."

info "Criando estrutura de diretórios..."
create_gui_tree
success "Estrutura base garantida."

# -------------------------------
# SOLUTION FIX (IMPORTANTE)
# -------------------------------

cd "$PROJECT_ROOT"

SOLUTION_FILE_SLSN="$PROJECT_ROOT/DotNetProjectWizard.GUI.sln"
SOLUTION_FILE_SLNX="$PROJECT_ROOT/DotNetProjectWizard.GUI.slnx"

if [[ -f "$SOLUTION_FILE_SLSN" || -f "$SOLUTION_FILE_SLNX" ]]; then
    warning "Solution já existe (.sln ou .slnx). Pulando criação."
else
    info "Criando Solution principal..."
    dotnet new sln -n "DotNetProjectWizard.GUI"
    success "Solution criada."
fi

# -------------------------------
# AVALONIA PROJECT
# -------------------------------

mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

info "Verificando template Avalonia..."
install_template
success "Template Avalonia pronto."

if [[ -d "$APP_NAME" ]]; then
    warning "Projeto Avalonia já existe, pulando criação."
else
    info "Criando projeto Avalonia..."
    dotnet new avalonia.app -n "$APP_NAME"
    success "Projeto Avalonia criado."
fi

cd "$PROJECT_ROOT"

info "Adicionando projeto à Solution..."

dotnet sln add "$SRC_DIR/$APP_NAME/$APP_NAME.csproj" 2>/dev/null || \
warning "Projeto já estava adicionado."

info "Restaurando dependências..."
cd "$SRC_DIR/$APP_NAME"
dotnet restore
success "Restore concluído."

info "Build inicial..."
dotnet build
success "Build finalizado com sucesso."

echo
echo "========================================="
echo " SCRIPT 02 FINALIZADO (FIXED)"
echo "========================================="
echo
echo "Projeto:"
echo "  $APP_NAME"
echo
echo "Próximo script:"
echo "  03-mvvm-core.sh"
echo "========================================="
