#!/usr/bin/env bash

set -euo pipefail

FILE="$HOME/DotNetProjectWizard/src/DotNetProjectWizard/CommandDispatcher.cs"

cat > "$FILE" <<'CSHARP'
using System;
using System.IO;

namespace DotNetProjectWizard;

public class CommandDispatcher
{
    private readonly IShellExecutor _shell;

    private readonly string Root =
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
            Console.WriteLine("projectwizard list | new <template>");
            return;
        }

        switch (args[0])
        {
            case "new":
                RunNew(args);
                break;
        }
    }

    private void RunNew(string[] args)
    {
        if (args.Length < 2)
            return;

        var template = args[1];

        var script = Path.Combine(Root, "scripts", template, "01-create-solution.sh");

        if (!File.Exists(script))
        {
            Console.WriteLine("Template not found.");
            return;
        }

        _shell.Execute($"bash \"{script}\"");
    }
}
CSHARP

echo "Path normalization done."
