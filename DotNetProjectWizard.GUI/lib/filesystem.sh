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

