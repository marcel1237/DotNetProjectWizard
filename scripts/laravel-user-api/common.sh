#!/usr/bin/env bash

###############################################################################
# DotNetProjectWizard
# Common Library
###############################################################################

set -Eeuo pipefail

START_TIME=$(date +%s)
SCRIPT_NAME="$(basename "${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}")"

###############################################################################
# Colors
###############################################################################

if [[ -t 1 ]]; then
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    BLUE="\033[0;34m"
    CYAN="\033[0;36m"
    WHITE="\033[1;37m"
    NC="\033[0m"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    CYAN=""
    WHITE=""
    NC=""
fi

###############################################################################
# Logging
###############################################################################

info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

success() {
    echo -e "${GREEN}[ OK ]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[FAIL]${NC} $*"
}

title() {

    echo
    echo "=============================================================="
    echo " DotNetProjectWizard"
    echo " $1"
    echo "=============================================================="
    echo

}

###############################################################################
# Pause
###############################################################################

pause() {

    echo
    read -rp "Pressione ENTER para continuar..."
    echo

}

###############################################################################
# Detect Distro
###############################################################################

detect_distro() {

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO="$ID"
    else
        DISTRO="unknown"
    fi

}

###############################################################################
# Sudo
###############################################################################

need_sudo() {

    if [ "$EUID" -ne 0 ]; then
        SUDO="sudo"
    else
        SUDO=""
    fi

}

###############################################################################
# Package Installation
###############################################################################

install_package() {

    need_sudo
    detect_distro

    local pkg="$1"

    case "$DISTRO" in

        ubuntu|debian)

            if ! dpkg -s "$pkg" >/dev/null 2>&1; then

                info "Installing $pkg..."

                $SUDO apt update

                $SUDO apt install -y "$pkg"

            fi

            ;;

        fedora)

            $SUDO dnf install -y "$pkg"

            ;;

        arch)

            $SUDO pacman -S --noconfirm "$pkg"

            ;;

        *)

            warn "Unknown Linux distribution."

            ;;

    esac

}

###############################################################################
# Commands
###############################################################################

require_command() {

    local cmd="$1"
    shift

    if ! command -v "$cmd" >/dev/null 2>&1; then

        warn "$cmd not found."

        install_package "$@"

        if ! command -v "$cmd" >/dev/null 2>&1; then

            error "$cmd installation failed."

            exit 1

        fi

    fi

}

###############################################################################
# Internet
###############################################################################

check_internet() {

    info "Checking internet connection..."

    if ping -c1 github.com >/dev/null 2>&1; then

        success "Internet OK"

    else

        error "No internet connection."

        exit 1

    fi

}

###############################################################################
# Disk
###############################################################################

check_disk_space() {

    local required=1048576

    local available

    available=$(df "$HOME" | awk 'NR==2 {print $4}')

    if [ "$available" -lt "$required" ]; then

        error "Not enough disk space."

        exit 1

    fi

}

###############################################################################
# Git
###############################################################################

git_available() {

    require_command git git

}

###############################################################################
# PHP
###############################################################################

php_available() {

    if command -v php >/dev/null 2>&1; then
        return
    fi

    info "Installing PHP..."

    detect_distro
    need_sudo

    case "$DISTRO" in

        ubuntu|debian)

            $SUDO apt update

            $SUDO apt install -y \
                php-cli \
                php-common \
                php-curl \
                php-xml \
                php-mbstring \
                php-mysql \
                php-zip \
                php-bcmath \
                php-intl

            ;;

        *)

            error "Automatic PHP installation not supported."

            exit 1

            ;;

    esac

}

###############################################################################
# Composer
###############################################################################

composer_available() {

    if command -v composer >/dev/null 2>&1; then
        return
    fi

    info "Installing Composer..."

    detect_distro
    need_sudo

    case "$DISTRO" in

        ubuntu|debian)

            $SUDO apt update

            $SUDO apt install -y composer

            ;;

        *)

            error "Automatic Composer installation not supported."

            exit 1

            ;;

    esac

}

###############################################################################
# Docker
###############################################################################

docker_available() {

    if command -v docker >/dev/null 2>&1; then
        return
    fi

    warn "Docker is not installed."

}

###############################################################################
# Cleanup
###############################################################################

cleanup() {

    local exit_code=$?

    local END_TIME

    END_TIME=$(date +%s)

    local elapsed

    elapsed=$((END_TIME - START_TIME))

    echo

    echo "=============================================================="

    if [ "$exit_code" -eq 0 ]; then

        success "Finished successfully."

    else

        error "Finished with errors."

        echo "Exit Code : $exit_code"

    fi

    echo "Execution Time : ${elapsed}s"

    echo "=============================================================="

    pause

}

###############################################################################
# Error Handler
###############################################################################

on_error() {

    local exit_code=$?

    local line="$1"

    local command="$2"

    echo

    echo "=============================================================="

    error "Unexpected error"

    echo

    echo "Script : $SCRIPT_NAME"

    echo "Line   : $line"

    echo "Command:"

    echo "$command"

    echo

    echo "Exit Code : $exit_code"

    echo

}

###############################################################################
# CTRL+C
###############################################################################

on_interrupt() {

    echo

    warn "Execution cancelled by user."

    exit 130

}

###############################################################################
# Init
###############################################################################

init_script() {

    title "$1"

    check_internet

    check_disk_space

    git_available

    php_available

    composer_available

}

###############################################################################
# Traps
###############################################################################

trap 'on_error ${LINENO} "$BASH_COMMAND"' ERR
trap cleanup EXIT
trap on_interrupt SIGINT SIGTERM