#!/usr/bin/env bash
#
# ==============================================================================
# DotNetProjectWizard Patch Framework
#
# Fix Engine
#
# Alpha 0.1.0
# ==============================================================================
#

set -Eeuo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

###############################################################################
# STATISTICS
###############################################################################

FIXES_APPLIED=0
FILES_MODIFIED=0
FILES_SCANNED=0

###############################################################################
# INTERNAL
###############################################################################

inc_fix() {
    ((FIXES_APPLIED++))
}

inc_file() {
    ((FILES_MODIFIED++))
}

scan_file() {
    ((FILES_SCANNED++))
}

###############################################################################
# BACKUP
###############################################################################

safe_backup() {

    local file="$1"

    [[ -f "$file" ]] || return 0

    backup_file "$file"

}

###############################################################################
# REPLACE
###############################################################################

safe_replace() {

    local file="$1"
    local search="$2"
    local replace="$3"

    scan_file

    grep -q "$search" "$file" || return 0

    safe_backup "$file"

    sed -i "s|$search|$replace|g" "$file"

    inc_fix
    inc_file

    ok "$(basename "$file") atualizado."

}

###############################################################################
# INSERT AFTER
###############################################################################

insert_after() {

    local file="$1"
    local after="$2"
    local insert="$3"

    scan_file

    grep -qF "$insert" "$file" && return 0

    safe_backup "$file"

    sed -i "/$after/a\\
$insert
" "$file"

    inc_fix
    inc_file

}

###############################################################################
# INSERT BEFORE
###############################################################################

insert_before() {

    local file="$1"
    local before="$2"
    local insert="$3"

    scan_file

    grep -qF "$insert" "$file" && return 0

    safe_backup "$file"

    sed -i "/$before/i\\
$insert
" "$file"

    inc_fix
    inc_file

}

###############################################################################
# APPEND
###############################################################################

append_if_missing() {

    local file="$1"
    local line="$2"

    scan_file

    grep -qF "$line" "$file" && return 0

    safe_backup "$file"

    echo "$line" >> "$file"

    inc_fix
    inc_file

}

###############################################################################
# UTF8
###############################################################################

fix_utf8() {

    section "UTF-8"

    while IFS= read -r file
    do

        scan_file

        iconv -f UTF-8 -t UTF-8 "$file" -o "$file.tmp" 2>/dev/null || continue

        if ! cmp -s "$file" "$file.tmp"
        then

            safe_backup "$file"

            mv "$file.tmp" "$file"

            inc_fix
            inc_file

            ok "$(basename "$file")"

        else

            rm "$file.tmp"

        fi

    done < <(find "$PROJECT_ROOT" -type f)

}

###############################################################################
# CRLF
###############################################################################

fix_line_endings() {

    section "CRLF"

    while IFS= read -r file
    do

        scan_file

        if file "$file" | grep -q CRLF
        then

            safe_backup "$file"

            sed -i 's/\r$//' "$file"

            inc_fix
            inc_file

            ok "$(basename "$file")"

        fi

    done < <(find "$PROJECT_ROOT" \
        -name "*.cs" \
        -o -name "*.axaml" \
        -o -name "*.csproj" \
        -o -name "*.props")

}

###############################################################################
# EMPTY FILES
###############################################################################

fix_empty_files() {

    section "Arquivos vazios"

    while IFS= read -r file
    do

        scan_file

        if [[ ! -s "$file" ]]
        then

            warn "$file vazio."

        fi

    done < <(find "$PROJECT_ROOT" -type f)

}

###############################################################################
# BOM
###############################################################################

remove_bom() {

    section "BOM"

    while IFS= read -r file
    do

        scan_file

        if head -c3 "$file" | grep -q $'\xef\xbb\xbf'
        then

            safe_backup "$file"

            tail --bytes=+4 "$file" > "$file.tmp"

            mv "$file.tmp" "$file"

            inc_fix
            inc_file

            ok "$(basename "$file")"

        fi

    done < <(find "$PROJECT_ROOT" \
        -name "*.cs" \
        -o -name "*.axaml" \
        -o -name "*.csproj")

}

###############################################################################
# SUMMARY
###############################################################################

fix_summary() {

    section "Correções"

    echo "Arquivos analisados : $FILES_SCANNED"

    echo "Arquivos alterados  : $FILES_MODIFIED"

    echo "Correções aplicadas : $FIXES_APPLIED"

    report ""
    report "## Correções"
    report ""
    report "- Arquivos analisados: $FILES_SCANNED"
    report "- Arquivos alterados: $FILES_MODIFIED"
    report "- Correções aplicadas: $FIXES_APPLIED"
    report ""

}

###############################################################################
# MAIN
###############################################################################

run_base_fixes() {

    fix_utf8

    remove_bom

    fix_line_endings

    fix_empty_files

}

###############################################################################
# XAML FIXES
###############################################################################

is_resource_dictionary() {

    local file="$1"

    grep -q "<ResourceDictionary" "$file"

}

uses_x_namespace() {

    local file="$1"

    grep -q "x:" "$file"

}

has_x_namespace() {

    local file="$1"

    grep -q 'xmlns:x=' "$file"

}

###############################################################################
# FIX xmlns:x
###############################################################################

fix_xmlns_x() {

    section "Corrigindo xmlns:x"

    while IFS= read -r file
    do

        scan_file

        is_resource_dictionary "$file" || continue

        uses_x_namespace "$file" || continue

        has_x_namespace "$file" && continue

        info "Corrigindo: ${file#$PROJECT_ROOT/}"

        safe_backup "$file"

        awk '
        BEGIN { done=0 }

        {
            print

            if(done==0 && $0 ~ /<ResourceDictionary/)
            {
                print "    xmlns:x=\"http://schemas.microsoft.com/winfx/2006/xaml\""
                done=1
            }
        }
        ' "$file" > "$file.tmp"

        mv "$file.tmp" "$file"

        inc_fix
        inc_file

        ok "xmlns:x inserido."

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml" | sort)

}

###############################################################################
# VALIDAÇÃO ResourceDictionary
###############################################################################

validate_resource_dictionary() {

    section "Validando ResourceDictionary"

    while IFS= read -r file
    do

        scan_file

        is_resource_dictionary "$file" || continue

        if ! grep -q "</ResourceDictionary>" "$file"
        then

            warn "ResourceDictionary inválido:"

            echo "    ${file#$PROJECT_ROOT/}"

            report "- ResourceDictionary inválido: ${file#$PROJECT_ROOT/}"

        fi

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml" | sort)

}

###############################################################################
# COLOR KEYS
###############################################################################

audit_color_keys() {

    section "Auditando Color Keys"

    while IFS= read -r file
    do

        scan_file

        grep -q "<Color" "$file" || continue

        if grep "<Color" "$file" | grep -v "x:Key" >/dev/null
        then

            warn "Color sem x:Key"

            echo "    ${file#$PROJECT_ROOT/}"

            report "- Color sem x:Key: ${file#$PROJECT_ROOT/}"

        fi

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml" | sort)

}

###############################################################################
# BRUSH KEYS
###############################################################################

audit_brush_keys() {

    section "Auditando Brush Keys"

    while IFS= read -r file
    do

        scan_file

        grep -q "Brush" "$file" || continue

        if grep "Brush" "$file" | grep -v "x:Key" >/dev/null
        then

            warn "Brush sem x:Key"

            echo "    ${file#$PROJECT_ROOT/}"

            report "- Brush sem x:Key: ${file#$PROJECT_ROOT/}"

        fi

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml" | sort)

}

###############################################################################
# RUN
###############################################################################

run_xaml_fixes_part1() {

    fix_xmlns_x

    validate_resource_dictionary

    audit_color_keys

    audit_brush_keys

}


###############################################################################
# APP.AXAML
###############################################################################

fix_app_axaml() {

    section "Validando App.axaml"

    while IFS= read -r file
    do

        scan_file

        [[ "$(basename "$file")" != "App.axaml" ]] && continue

        info "Verificando ${file#$PROJECT_ROOT/}"

        grep -q "<Application" "$file" || {

            warn "Application tag não encontrada."

            continue

        }

        grep -q "</Application>" "$file" || {

            warn "Application não finalizado."

            continue

        }

        ok "App.axaml válido."

    done < <(find "$PROJECT_ROOT/src" -name "App.axaml")

}

###############################################################################
# MERGEDDICTIONARIES
###############################################################################

audit_merged_dictionaries() {

    section "MergedDictionaries"

    while IFS= read -r file
    do

        scan_file

        grep -q "MergedDictionaries" "$file" || continue

        info "Verificando ${file#$PROJECT_ROOT/}"

        if ! grep -q "<ResourceInclude" "$file"
        then

            warn "MergedDictionaries sem ResourceInclude."

            report "- MergedDictionaries vazio: ${file#$PROJECT_ROOT/}"

        fi

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml")

}

###############################################################################
# STYLEINCLUDE
###############################################################################

audit_style_include() {

    section "StyleInclude"

    while IFS= read -r file
    do

        scan_file

        grep -q "StyleInclude" "$file" || continue

        while read -r line
        do

            if echo "$line" | grep -q 'Source='
            then

                ok "$(basename "$file")"

            fi

        done < "$file"

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml")

}

###############################################################################
# THEMEDICTIONARIES
###############################################################################

audit_theme_dictionaries() {

    section "ThemeDictionaries"

    while IFS= read -r file
    do

        scan_file

        grep -q "ThemeDictionaries" "$file" || continue

        info "${file#$PROJECT_ROOT/}"

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml")

}

###############################################################################
# RESOURCE INCLUDE
###############################################################################

audit_resource_include() {

    section "ResourceInclude"

    while IFS= read -r file
    do

        scan_file

        grep -q "<ResourceInclude" "$file" || continue

        while read -r line
        do

            echo "$line" | grep -q "Source=" || continue

            src=$(echo "$line" | sed -n 's/.*Source="\([^"]*\)".*/\1/p')

            [[ -z "$src" ]] && continue

            ok "$src"

        done < "$file"

    done < <(find "$PROJECT_ROOT/src" -name "*.axaml")

}

###############################################################################
# DUPLICATE KEYS
###############################################################################

audit_duplicate_keys() {

    section "Duplicate Keys"

    local tmp

    tmp=$(mktemp)

    grep -R "x:Key=" "$PROJECT_ROOT/src" \
        --include="*.axaml" \
        | sed 's/.*x:Key="//' \
        | sed 's/".*//' \
        | sort > "$tmp"

    duplicates=$(uniq -d "$tmp")

    if [[ -n "$duplicates" ]]
    then

        warn "Chaves duplicadas encontradas."

        echo "$duplicates"

        report ""
        report "## Duplicate Keys"
        report ""
        report '```'
        report "$duplicates"
        report '```'

    else

        ok "Nenhuma chave duplicada."

    fi

    rm -f "$tmp"

}

###############################################################################
# RUN PART 2
###############################################################################

run_xaml_fixes_part2() {

    fix_app_axaml

    audit_merged_dictionaries

    audit_style_include

    audit_theme_dictionaries

    audit_resource_include

    audit_duplicate_keys

}


###############################################################################
# XAML FIX PIPELINE
###############################################################################

run_xaml_fixes() {

    section "Avalonia XAML Fix Pipeline"

    info "Iniciando auditoria e correções XAML..."

    echo

    ###########################################################################
    # PARTE 1
    ###########################################################################

    run_xaml_fixes_part1

    ###########################################################################
    # PARTE 2
    ###########################################################################

    run_xaml_fixes_part2

    ###########################################################################
    # RESUMO
    ###########################################################################

    section "Resumo XAML"

    echo "Arquivos analisados : $FILES_SCANNED"

    echo "Arquivos alterados  : $FILES_MODIFIED"

    echo "Correções aplicadas : $FIXES_APPLIED"

    report ""
    report "## XAML Fix Pipeline"
    report ""
    report "| Item | Quantidade |"
    report "|------|-----------:|"
    report "| Arquivos analisados | $FILES_SCANNED |"
    report "| Arquivos alterados | $FILES_MODIFIED |"
    report "| Correções aplicadas | $FIXES_APPLIED |"
    report ""

}

###############################################################################
# COMPLETE PATCH PIPELINE
###############################################################################

run_patch_fixes() {

    section "Patch Engine"

    ###########################################################################
    # BASE
    ###########################################################################

    info "Executando correções gerais..."

    run_base_fixes

    echo

    ###########################################################################
    # XAML
    ###########################################################################

    info "Executando correções Avalonia..."

    run_xaml_fixes

    echo

    ###########################################################################
    # BUILD
    ###########################################################################

    section "Validação"

    if run_restore
    then

        ok "Restore OK."

        report "- Restore............. OK"

    else

        warn "Restore apresentou problemas."

        report "- Restore............. FAILED"

    fi

    echo

    if run_build
    then

        ok "Build OK."

        report "- Build............... OK"

    else

        warn "Build apresentou erros."

        report "- Build............... FAILED"

    fi

    echo

    ###########################################################################
    # SUMMARY
    ###########################################################################

    fix_summary

}

###############################################################################
# PATCH VERSION
###############################################################################

patch_engine_version() {

    echo "Patch Engine Alpha 0.1.0"

}

