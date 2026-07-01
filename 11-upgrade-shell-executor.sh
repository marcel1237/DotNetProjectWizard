#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="DotNetProjectWizard"
FILE="$HOME/$PROJECT_NAME/src/$PROJECT_NAME/Shell/ShellExecutor.cs"

cat > "$FILE" <<'CSHARP'
using System;
using System.Diagnostics;

namespace DotNetProjectWizard;

public class ShellExecutor : IShellExecutor
{
    public int Execute(string command)
    {
        Console.WriteLine($"[shell] {command}");

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

        string output = process.StandardOutput.ReadToEnd();
        string error = process.StandardError.ReadToEnd();

        process.WaitForExit();

        if (!string.IsNullOrWhiteSpace(output))
            Console.WriteLine(output);

        if (!string.IsNullOrWhiteSpace(error))
            Console.WriteLine("[error] " + error);

        Console.WriteLine($"[exit] {process.ExitCode}");

        return process.ExitCode;
    }
}
CSHARP

echo "ShellExecutor upgraded."
