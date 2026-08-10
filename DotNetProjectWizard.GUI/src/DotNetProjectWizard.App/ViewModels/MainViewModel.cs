using System.Windows.Input;
using DotNetProjectWizard.App.ViewModels.Base;
using DotNetProjectWizard.App.Commands;
using DotNetProjectWizard.App.Services.Navigation;
using DotNetProjectWizard.App.ViewModels.Home;
using DotNetProjectWizard.App.ViewModels.NewProject;

namespace DotNetProjectWizard.App.ViewModels;

public class MainViewModel : ViewModelBase
{
    private readonly NavigationService _navigation;

    private object? _currentView;

    public object? CurrentView
    {
        get => _currentView;
        set => SetProperty(ref _currentView, value);
    }

    public ICommand HomeCommand { get; }
    public ICommand NewProjectCommand { get; }

    public MainViewModel(NavigationService navigation)
    {
        _navigation = navigation;

        var home = new HomeViewModel();
        var newProject = new NewProjectViewModel();

        CurrentView = home;

        HomeCommand = new RelayCommand(() =>
        {
            _navigation.NavigateTo(home);
            CurrentView = _navigation.CurrentView;
        });

        NewProjectCommand = new RelayCommand(() =>
        {
            _navigation.NavigateTo(newProject);
            CurrentView = _navigation.CurrentView;
        });
    }
}
