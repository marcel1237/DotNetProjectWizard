#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="DotNetProjectWizard"
ROOT="$HOME/$PROJECT_NAME"

FILE="$ROOT/src/$PROJECT_NAME/CommandDispatcher.cs"

cat > "$FILE" <<'CSHARP'
using System;
using System.IO;

namespace DotNetProjectWizard;

public class CommandDispatcher
{
    private readonly IShellExecutor _shell;

    private readonly string _root =
        Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
        "DotNetProjectWizard");

    public CommandDispatcher(IShellExecutor shell)
    {
        _shell = shell;
    }

    public void Dispatch(string[] args)
    {
        if (args.Length == 0)
        {
            Console.WriteLine("projectwizard new <template>");
            return;
        }

        if (args[0] == "new")
        {
            if (args.Length < 2)
            {
                Console.WriteLine("Missing template");
                return;
            }

            var template = args[1];
            var script = Path.Combine(_root, "scripts", template, "01-create-solution.sh");

            if (!File.Exists(script))
            {
                Console.WriteLine("Template not found: " + template);
                return;
            }

            _shell.Execute($"bash \"{script}\"");
        }
    }
}
CSHARP

echo "Template validation added."
