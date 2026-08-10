#!/usr/bin/env bash

source "$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI/lib/common.sh"

check_dotnet() {

require dotnet

}

sdk_version() {

dotnet --version

}

restore() {

dotnet restore

}

build() {

dotnet build

}

