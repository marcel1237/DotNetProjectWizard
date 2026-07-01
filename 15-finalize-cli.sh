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
    private readonly string Root;

    public CommandDispatcher(IShellExecutor shell)
    {
        _shell = shell;
        Root = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "DotNetProjectWizard");
    }

    public void Dispatch(string[] args)
    {
        if (args.Length == 0)
        {
            Print();
            return;
        }

        switch (args[0])
        {
            case "new":
                Run(args);
                break;

            case "list":
                List();
                break;

            default:
                Print();
                break;
        }
    }

    void Print()
    {
        Console.WriteLine("DotNetProjectWizard");
        Console.WriteLine(" new <template>");
        Console.WriteLine(" list");
    }

    void List()
    {
        var dir = Path.Combine(Root, "scripts");

        foreach (var d in Directory.GetDirectories(dir))
            Console.WriteLine("- " + Path.GetFileName(d));
    }

    void Run(string[] args)
    {
        if (args.Length < 2)
            return;

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

echo "CLI finalized."
