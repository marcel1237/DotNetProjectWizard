namespace DotNetProjectWizard.App.Services.Interfaces;

public interface INavigationService
{
    void NavigateTo<TViewModel>() where TViewModel : class;
    object? CurrentView { get; }
}
