using Avalonia.Controls;
using DotNetProjectWizard.App.Views.Home;
using DotNetProjectWizard.App.ViewModels.Home;

namespace DotNetProjectWizard.App.Services.ViewLocator;

public static class ViewLocator
{
    public static Control Resolve(object viewModel)
    {
        return viewModel switch
        {
            HomeViewModel => new HomeView(),
            _ => new TextBlock { Text = "View not found" }
        };
    }
}
