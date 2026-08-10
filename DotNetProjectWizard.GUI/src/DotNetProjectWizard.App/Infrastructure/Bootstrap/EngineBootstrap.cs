using DotNetProjectWizard.App.Infrastructure.DI;
using DotNetProjectWizard.App.Infrastructure.Logging;
using DotNetProjectWizard.App.Services.Factories;
using DotNetProjectWizard.App.Services.Registry;
using DotNetProjectWizard.App.Services.Navigation;

namespace DotNetProjectWizard.App.Infrastructure.Bootstrap;

public class EngineBootstrap
{
    public Engine Engine { get; private set; } = null!;
    public ServiceContainer Services => Engine.Services;

    public void Initialize()
    {
        Engine = new Engine();
        Engine.Configure();
    }

    public T Get<T>() where T : class
    {
        return Services.Get<T>();
    }
}
