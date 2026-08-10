#!/usr/bin/env bash
#
# DotNetProjectWizard
# Phase 1 - Script 02
# Create Avalonia Project
#

set -Eeuo pipefail

PROJECT_NAME="DotNetProjectWizard.GUI"
ROOT="$HOME/DotNetProjectWizard/$PROJECT_NAME"

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

trap 'echo -e "\n${RED}Erro na linha $LINENO${RESET}"; exit 1' ERR

banner() {

echo
echo -e "${CYAN}"
echo "=============================================================="
echo "      DotNetProjectWizard GUI - Create Avalonia Project"
echo "=============================================================="
echo -e "${RESET}"

}

info() {

echo -e "${BLUE}[INFO]${RESET} $1"

}

ok() {

echo -e "${GREEN}[ OK ]${RESET} $1"

}

warn() {

echo -e "${YELLOW}[WARN]${RESET} $1"

}

require() {

command -v "$1" >/dev/null 2>&1 || {
    echo -e "${RED}$1 não encontrado.${RESET}"
    exit 1
}

}

banner

require dotnet

cd "$ROOT"

info "Verificando templates Avalonia..."

if ! dotnet new list | grep -qi avalonia; then

    info "Instalando template Avalonia..."

    dotnet new install Avalonia.Templates

    ok "Template instalado."

else

    ok "Template Avalonia já instalado."

fi

mkdir -p src

cd src

APP_NAME="DotNetProjectWizard.App"

if [[ -d "$APP_NAME" ]]; then

    warn "Projeto já existe."

else

    info "Criando projeto Avalonia..."

    dotnet new avalonia.app \
        -n "$APP_NAME"

    ok "Projeto criado."

fi

cd "$APP_NAME"

info "Criando estrutura de diretórios..."

mkdir -p Assets

mkdir -p Controls

mkdir -p Converters

mkdir -p Extensions

mkdir -p Helpers

mkdir -p Models

mkdir -p Services

mkdir -p Themes

mkdir -p ViewModels

mkdir -p Views

mkdir -p Resources

mkdir -p Dialogs

mkdir -p Icons

mkdir -p Styles

mkdir -p Commands

mkdir -p Configuration

mkdir -p Logging

mkdir -p Localization

mkdir -p Plugins

mkdir -p Shell

ok "Estrutura criada."

cd "$ROOT"

info "Adicionando projeto na Solution..."

dotnet sln add src/$APP_NAME/$APP_NAME.csproj

ok "Projeto adicionado."

info "Restaurando pacotes..."

dotnet restore

ok "Restore concluído."

info "Compilando..."

dotnet build

ok "Build realizado."

echo

echo "=============================================================="

echo "Projeto Avalonia criado com sucesso."

echo

echo "Local:"

echo

echo "   $ROOT/src/$APP_NAME"

echo

echo "Próximo script:"

echo

echo "03-create-mvvm.sh"

echo

echo "=============================================================="

