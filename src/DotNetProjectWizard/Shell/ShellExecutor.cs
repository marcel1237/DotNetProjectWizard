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
