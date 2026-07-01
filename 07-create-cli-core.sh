#!/usr/bin/env bash

set -euo pipefail

########################################
# DotNet Project Wizard
# Step 07
# Create CLI Core Architecture
########################################

PROJECT_NAME="DotNetProjectWizard"

ROOT_DIR="$HOME/$PROJECT_NAME"
APP_DIR="$ROOT_DIR/src/$PROJECT_NAME"

echo
echo "========================================="
echo " DotNet Project Wizard"
echo " Step 07 - Create CLI Core"
echo "========================================="
echo

if [ ! -d "$APP_DIR" ]; then
    echo "ERROR:"
    echo "Project source not found:"
    echo "  $APP_DIR"
    exit 1
fi

########################################
# Program.cs
########################################

cat > "$APP_DIR/Program.cs" <<'CSHARP'
using System;

namespace DotNetProjectWizard;

class Program
{
    static void Main(string[] args)
    {
        var dispatcher = new CommandDispatcher(new ShellExecutor());
        dispatcher.Dispatch(args);
    }
}
CSHARP

########################################
# IShellExecutor.cs
########################################

mkdir -p "$APP_DIR/Shell"

cat > "$APP_DIR/Shell/IShellExecutor.cs" <<'CSHARP'
using System;

namespace DotNetProjectWizard;

public interface IShellExecutor
{
    int Execute(string command);
}
CSHARP

########################################
# ShellExecutor.cs
########################################

cat > "$APP_DIR/Shell/ShellExecutor.cs" <<'CSHARP'
using System;
using System.Diagnostics;

namespace DotNetProjectWizard;

public class ShellExecutor : IShellExecutor
{
    public int Execute(string command)
    {
        var process = new Process
        {
            StartInfo = new ProcessStartInfo
            {
                FileName = "/bin/bash",
                Arguments = $"-c \"{command}\"",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            }
        };

        process.Start();
        process.WaitForExit();

        Console.WriteLine(process.StandardOutput.ReadToEnd());
        Console.WriteLine(process.StandardError.ReadToEnd());

        return process.ExitCode;
    }
}
CSHARP

########################################
# CommandDispatcher.cs
########################################

mkdir -p "$APP_DIR/Commands"

cat > "$APP_DIR/CommandDispatcher.cs" <<'CSHARP'
using System;

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
            Console.WriteLine("Usage: projectwizard <command>");
            return;
        }

        var command = args[0];

        Console.WriteLine($"Executing command: {command}");

        // Placeholder for future commands
        _shell.Execute("echo 'No command implemented yet'");
    }
}
CSHARP

########################################
# BaseCommand.cs
########################################

cat > "$APP_DIR/Commands/BaseCommand.cs" <<'CSHARP'
namespace DotNetProjectWizard;

public abstract class BaseCommand
{
    public abstract string Name { get; }

    public abstract void Execute(string[] args);
}
CSHARP

echo
echo "========================================="
echo " CLI Core created successfully!"
echo "========================================="
echo

echo "Files created:"
echo "  Program.cs"
echo "  Shell/IShellExecutor.cs"
echo "  Shell/ShellExecutor.cs"
echo "  CommandDispatcher.cs"
echo "  Commands/BaseCommand.cs"
echo

