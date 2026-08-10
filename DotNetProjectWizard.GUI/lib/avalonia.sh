#!/usr/bin/env bash

source "$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI/lib/common.sh"

install_template() {

if ! dotnet new list | grep -qi Avalonia
then
    dotnet new install Avalonia.Templates
fi

}

