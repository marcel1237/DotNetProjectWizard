using System.Collections.ObjectModel;
using DotNetProjectWizard.App.ViewModels.Base;
using DotNetProjectWizard.App.Infrastructure.Logging;

namespace DotNetProjectWizard.App.ViewModels.Console;

public class ConsoleViewModel : ViewModelBase
{
    public ObservableCollection<LogEntry> Logs { get; } = new();

    public ConsoleViewModel(EngineLogger logger)
    {
        logger.OnLog += entry =>
        {
            Logs.Add(entry);
        };

        logger.Info("Dev Console initialized");
    }
}
