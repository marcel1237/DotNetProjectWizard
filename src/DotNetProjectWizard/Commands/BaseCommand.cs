namespace DotNetProjectWizard;

public abstract class BaseCommand
{
    public abstract string Name { get; }

    public abstract void Execute(string[] args);
}
