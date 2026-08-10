using DotNetProjectWizard.App.Services.Navigation;
using DotNetProjectWizard.App.Services.Factories;
using DotNetProjectWizard.App.Services.Registry;
using DotNetProjectWizard.App.Infrastructure.Logging;

namespace DotNetProjectWizard.App.Infrastructure.DI;

public class Engine
{
    public ServiceContainer Services { get; } = new();

    public void Configure()
    {
        var logger = new EngineLogger();
        var factory = new ViewFactory();

        ViewRegistry.RegisterAll(factory);

        Services.AddSingleton(logger);
        Services.AddSingleton(factory);

        Services.AddSingleton(c =>
        {
            var f = c.Get<ViewFactory>();
            return new NavigationService(f);
        });

        logger.Info("Engine initialized");
    }
}
