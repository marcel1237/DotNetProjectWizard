#!/usr/bin/env bash
#
# DotNetProjectWizard
# Phase 1 - Script 01
# Bootstrap GUI
#

set -Eeuo pipefail

PROJECT_NAME="DotNetProjectWizard.GUI"
ROOT="$HOME/DotNetProjectWizard"
SOLUTION="$ROOT/$PROJECT_NAME"

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

trap 'echo -e "\n${RED}Erro na linha $LINENO.${RESET}"; exit 1' ERR

banner() {

echo

echo -e "${CYAN}"
echo "=============================================================="
echo "        DotNetProjectWizard GUI - Bootstrap"
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

info "Verificando dependências..."

require git
require dotnet
require curl
require unzip

ok "Dependências encontradas."

mkdir -p "$ROOT"

cd "$ROOT"

if [[ -d "$SOLUTION" ]]; then
    warn "Projeto já existe."
else
    mkdir -p "$SOLUTION"
fi

cd "$SOLUTION"

if [[ ! -f "$PROJECT_NAME.sln" ]]; then
    info "Criando Solution..."
    dotnet new sln --name "$PROJECT_NAME"
    ok "Solution criada."
fi

info "Criando estrutura..."

mkdir -p src
mkdir -p tests
mkdir -p docs
mkdir -p assets
mkdir -p resources
mkdir -p templates
mkdir -p scripts
mkdir -p config
mkdir -p logs
mkdir -p installer
mkdir -p packages
mkdir -p build
mkdir -p artifacts
mkdir -p backup
mkdir -p tmp

ok "Estrutura criada."

cat > README.md <<README
# DotNetProjectWizard GUI

Projeto da interface gráfica do DotNetProjectWizard.

Estrutura inicial criada automaticamente.
README

cat > .gitignore <<GIT
bin/
obj/
artifacts/
tmp/
backup/
logs/
.vscode/
.idea/
GIT

cat > config/appsettings.json <<JSON
{
  "Theme":"Dark",
  "Language":"pt-BR",
  "Version":"1.0.0"
}
JSON

cat > scripts/build.sh <<BUILD
#!/usr/bin/env bash
set -e
dotnet build
BUILD

cat > scripts/run.sh <<RUN
#!/usr/bin/env bash
set -e
dotnet run
RUN

cat > scripts/clean.sh <<CLEAN
#!/usr/bin/env bash
set -e
dotnet clean
rm -rf artifacts
rm -rf tmp
CLEAN

chmod +x scripts/*.sh

echo
echo "=============================================================="
echo "Estrutura criada com sucesso."
echo
echo "Local:"
echo "  $SOLUTION"
echo
echo "Próximo script:"
echo "  02-create-avalonia-project.sh"
echo "=============================================================="
