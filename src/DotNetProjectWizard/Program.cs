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
