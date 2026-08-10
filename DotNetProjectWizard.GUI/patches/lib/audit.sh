#!/usr/bin/env bash
#
# ================================================================
# DotNetProjectWizard Patch System
# Audit Library
# Alpha 0.1.0
# ================================================================
#

set -Eeuo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

################################################################################
# COUNTERS
################################################################################

TOTAL_AXAML=0
TOTAL_CSPROJ=0
TOTAL_CS=0

INVALID_XAML=0
MISSING_XMLNS_X=0

################################################################################
# HELPERS
################################################################################

append_report() {
    report "$@"
}

################################################################################
# AXAML
################################################################################

audit_axaml() {

    section "Auditoria AXAML"

    append_report "## Arquivos AXAML"
    append_report ""

    while IFS= read -r file
    do

        ((TOTAL_AXAML++))

        local relative="${file#$PROJECT_ROOT/}"

        local uses_x=0
        local has_namespace=0

        if grep -q "x:" "$file"; then
            uses_x=1
        fi

        if grep -q 'xmlns:x=' "$file"; then
            has_namespace=1
        fi

        if [[ "$uses_x" -eq 1 && "$has_namespace" -eq 0 ]]; then

            ((INVALID_XAML++))
            ((MISSING_XMLNS_X++))

            warn "$relative"

            append_report "- ❌ $relative (xmlns:x ausente)"

        else

            ok "$relative"

        fi

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml" | sort)

    echo

    info "Arquivos AXAML : $TOTAL_AXAML"

    info "Problemas       : $INVALID_XAML"

    append_report ""
}

################################################################################
# CSPROJ
################################################################################

audit_csproj() {

    section "Auditoria CSPROJ"

    append_report "## Projetos"

    while IFS= read -r file
    do

        ((TOTAL_CSPROJ++))

        local relative="${file#$PROJECT_ROOT/}"

        ok "$relative"

        append_report "- $relative"

        if ! grep -q "<TargetFramework>" "$file"; then

            warn "TargetFramework ausente"

            append_report "  - ⚠ TargetFramework ausente"

        fi

    done < <(find "$PROJECT_ROOT" -name "*.csproj" | sort)

    append_report ""
}

################################################################################
# C#
################################################################################

audit_cs() {

    section "Auditoria C#"

    TOTAL_CS=$(find "$PROJECT_ROOT/src" -name "*.cs" | wc -l)

    info "Arquivos C# : $TOTAL_CS"

    append_report "## Arquivos C#"

    append_report ""

    append_report "Total: $TOTAL_CS"

    append_report ""
}

################################################################################
# SOLUTION
################################################################################

audit_solution() {

    section "Solution"

    local count

    count=$(find "$PROJECT_ROOT" \( -name "*.sln" -o -name "*.slnx" \) | wc -l)

    info "Solutions encontradas : $count"

    append_report "## Solution"

    append_report ""

    append_report "Quantidade: $count"

    append_report ""

}

################################################################################
# PACKAGES
################################################################################

audit_packages() {

    section "NuGet"

    append_report "## SDK"

    append_report ""

    append_report "dotnet: $(dotnet --version)"

    append_report ""

}

################################################################################
# DIRECTORY
################################################################################

audit_structure() {

    section "Estrutura"

    append_report "## Estrutura"

    append_report ""

    for dir in \
        src \
        patches \
        Themes \
        Views \
        ViewModels \
        Infrastructure \
        Services
    do

        if find "$PROJECT_ROOT" -type d -name "$dir" | grep -q . ; then

            ok "$dir"

            append_report "- ✔ $dir"

        else

            warn "$dir"

            append_report "- ⚠ $dir"

        fi

    done

    append_report ""
}

################################################################################
# SUMMARY
################################################################################

audit_summary() {

    section "Resumo"

    echo "AXAML..................: $TOTAL_AXAML"
    echo "C#.....................: $TOTAL_CS"
    echo "CSPROJ.................: $TOTAL_CSPROJ"
    echo "xmlns:x ausentes.......: $MISSING_XMLNS_X"

    append_report "## Resumo"

    append_report ""

    append_report "| Item | Quantidade |"
    append_report "|------|-----------:|"
    append_report "| AXAML | $TOTAL_AXAML |"
    append_report "| C# | $TOTAL_CS |"
    append_report "| CSPROJ | $TOTAL_CSPROJ |"
    append_report "| xmlns:x ausente | $MISSING_XMLNS_X |"

    append_report ""

}

################################################################################
# MAIN AUDIT
################################################################################

run_audit() {

    audit_structure

    audit_solution

    audit_packages

    audit_csproj

    audit_axaml

    audit_cs

    audit_summary

}
