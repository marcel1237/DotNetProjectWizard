using System;

namespace DotNetProjectWizard.App.Services.Navigation;

public class NavigationService
{
    private readonly Services.Factories.ViewFactory _factory;

    public object? CurrentView { get; private set; }

    public NavigationService(Services.Factories.ViewFactory factory)
    {
        _factory = factory;
    }

    public void NavigateTo<TViewModel>(TViewModel viewModel) where TViewModel : class
    {
        CurrentView = _factory.Create(viewModel);
    }
}
