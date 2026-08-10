#!/usr/bin/env bash

LOGFILE="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI/logs/wizard.log"

mkdir -p "$(dirname "$LOGFILE")"

touch "$LOGFILE"

write_log() {

echo "$(date +"%F %T") $1" >> "$LOGFILE"

}

