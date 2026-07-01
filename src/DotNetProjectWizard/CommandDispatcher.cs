using System;
using System.IO;

namespace DotNetProjectWizard;

public class CommandDispatcher
{
    private readonly IShellExecutor _shell;

    private readonly string _rootDir = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
        "DotNetProjectWizard"
    );

    public CommandDispatcher(IShellExecutor shell)
    {
        _shell = shell;
    }

    public void Dispatch(string[] args)
    {
        if (args.Length == 0)
        {
            PrintHelp();
            return;
        }

        var command = args[0].ToLower();

        switch (command)
        {
            case "new":
                HandleNew(args);
                break;

            case "list":
                HandleList();
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

        var scriptPath = Path.Combine(
            _rootDir,
            "scripts",
            template,
            "01-create-solution.sh"
        );

        if (!File.Exists(scriptPath))
        {
            Console.WriteLine($"Template not found: {template}");
            return;
        }

        Console.WriteLine($"Running template: {template}");

        _shell.Execute($"bash \"{scriptPath}\"");
    }

    private void HandleList()
    {
        var scriptsDir = Path.Combine(_rootDir, "scripts");

        if (!Directory.Exists(scriptsDir))
        {
            Console.WriteLine("No templates found.");
            return;
        }

        Console.WriteLine("Available templates:");
        Console.WriteLine();

        foreach (var dir in Directory.GetDirectories(scriptsDir))
        {
            Console.WriteLine($"- {Path.GetFileName(dir)}");
        }

        Console.WriteLine();
    }

    private void PrintHelp()
    {
        Console.WriteLine("DotNetProjectWizard CLI");
        Console.WriteLine();
        Console.WriteLine("Commands:");
        Console.WriteLine("  new <template>   Create a new project");
        Console.WriteLine("  list             List available templates");
        Console.WriteLine();
    }
}
