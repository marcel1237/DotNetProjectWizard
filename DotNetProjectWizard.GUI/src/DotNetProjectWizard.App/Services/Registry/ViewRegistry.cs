using DotNetProjectWizard.App.Services.Factories;
using DotNetProjectWizard.App.ViewModels.Home;
using DotNetProjectWizard.App.Views.Home;
using DotNetProjectWizard.App.ViewModels.NewProject;
using DotNetProjectWizard.App.Views.NewProject;
using DotNetProjectWizard.App.ViewModels.Console;
using DotNetProjectWizard.App.Views.Console;

namespace DotNetProjectWizard.App.Services.Registry;

public static class ViewRegistry
{
    public static void RegisterAll(ViewFactory factory)
    {
        factory.Register<HomeViewModel, HomeView>();
        factory.Register<NewProjectViewModel, NewProjectView>();
        factory.Register<ConsoleViewModel, ConsoleView>();
    }
}
