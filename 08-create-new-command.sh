#!/usr/bin/env bash

set -euo pipefail

########################################
# DotNet Project Wizard
# Step 08
# Create "new" command integration
########################################

PROJECT_NAME="DotNetProjectWizard"

ROOT_DIR="$HOME/$PROJECT_NAME"
APP_DIR="$ROOT_DIR/src/$PROJECT_NAME"

COMMAND_FILE="$APP_DIR/CommandDispatcher.cs"

echo
echo "========================================="
echo " DotNet Project Wizard"
echo " Step 08 - Add 'new' Command"
echo "========================================="
echo

if [ ! -f "$COMMAND_FILE" ]; then
    echo "ERROR:"
    echo "CommandDispatcher not found:"
    echo "  $COMMAND_FILE"
    exit 1
fi

########################################
# Rewrite CommandDispatcher
########################################

cat > "$COMMAND_FILE" <<'CSHARP'
using System;
using System.Diagnostics;

namespace DotNetProjectWizard;

public class CommandDispatcher
{
    private readonly IShellExecutor _shell;

    public CommandDispatcher(IShellExecutor shell)
    {
        _shell = shell;
    }

    public void Dispatch(string[] args)
    {
        if (args.Length == 0)
        {
            Console.WriteLine("DotNetProjectWizard CLI");
            Console.WriteLine("Usage:");
            Console.WriteLine("  projectwizard new <template>");
            return;
        }

        var command = args[0].ToLower();

        switch (command)
        {
            case "new":
                HandleNew(args);
                break;

            default:
                Console.WriteLine($"Unknown command: {command}");
                break;
        }
    }

    private void HandleNew(string[] args)
    {
        if (args.Length < 2)
        {
            Console.WriteLine("Usage: projectwizard new <template>");
            return;
        }

        var template = args[1].ToLower();

        Console.WriteLine($"Creating new project from template: {template}");

        var scriptPath = $"$HOME/DotNetProjectWizard/scripts/{template}/01-create-solution.sh";

        _shell.Execute($"bash {scriptPath}");
    }
}
CSHARP

echo
echo "========================================="
echo " 'new' command added successfully!"
echo "========================================="
echo
echo "Usage example:"
echo "  projectwizard new api-rest"
echo
echo "It will execute:"
echo "  scripts/<template>/01-create-solution.sh"
echo

