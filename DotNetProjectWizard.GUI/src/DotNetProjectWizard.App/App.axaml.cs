using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;
using DotNetProjectWizard.App.Infrastructure.Bootstrap;
using DotNetProjectWizard.App.ViewModels;
using DotNetProjectWizard.App.ViewModels.Home;

namespace DotNetProjectWizard.App;

public partial class App : Application
{
    private EngineBootstrap _bootstrap = new();

    public override void Initialize()
    {
        AvaloniaXamlLoader.Load(this);
    }

    public override void OnFrameworkInitializationCompleted()
    {
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            _bootstrap.Initialize();

            var navigation = _bootstrap.Get<Services.Navigation.NavigationService>();
            var logger = _bootstrap.Get<Infrastructure.Logging.EngineLogger>();

            logger.Info("Application starting...");

            var home = new HomeViewModel();

            navigation.NavigateTo(home);

            var mainVM = new MainViewModel(navigation);

            desktop.MainWindow = new MainWindow
            {
                DataContext = mainVM
            };

            logger.Info("MainWindow initialized successfully");
        }

        base.OnFrameworkInitializationCompleted();
    }
}
