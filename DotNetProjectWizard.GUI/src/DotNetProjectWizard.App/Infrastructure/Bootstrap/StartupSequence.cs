using DotNetProjectWizard.App.Infrastructure.Logging;

namespace DotNetProjectWizard.App.Infrastructure.Bootstrap;

public static class StartupSequence
{
    public static void Run(EngineBootstrap bootstrap)
    {
        var logger = bootstrap.Get<EngineLogger>();

        logger.Info("=== ENGINE BOOT START ===");
        logger.Info("Loading modules...");
        logger.Info("Initializing ViewFactory...");
        logger.Info("Initializing NavigationService...");
        logger.Info("Loading UI system...");
        logger.Info("Engine ready.");
        logger.Info("=== BOOT COMPLETE ===");
    }
}
