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
    private readonly string Root = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "DotNetProjectWizard");

    public CommandDispatcher(IShellExecutor shell)
    {
        _shell = shell;
    }

    public void Dispatch(string[] args)
    {
        if (args.Length == 0)
        {
            Help();
            return;
        }

        switch (args[0])
        {
            case "new":
                New(args);
                break;

            case "list":
                List();
                break;

            default:
                Help();
                break;
        }
    }

    void Help()
    {
        Console.WriteLine("projectwizard commands:");
        Console.WriteLine("  new <template>");
        Console.WriteLine("  list");
    }

    void List()
    {
        var dir = Path.Combine(Root, "scripts");

        if (!Directory.Exists(dir))
        {
            Console.WriteLine("No templates");
            return;
        }

        foreach (var d in Directory.GetDirectories(dir))
            Console.WriteLine(Path.GetFileName(d));
    }

    void New(string[] args)
    {
        if (args.Length < 2) return;

        var script = Path.Combine(Root, "scripts", args[1], "01-create-solution.sh");

        if (!File.Exists(script))
        {
            Console.WriteLine("Template not found");
            return;
        }

        _shell.Execute($"bash \"{script}\"");
    }
}
CSHARP

echo "Help system added."
