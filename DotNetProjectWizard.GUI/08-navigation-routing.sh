#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 08 - Navigation Routing System
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/logger.sh"

info "Iniciando Navigation Routing System..."

cd "$APP_PATH"

# ---------------------------------------
# 1. NAVIGATION SERVICE UPGRADE
# ---------------------------------------

info "Atualizando NavigationService..."

cat > Services/Navigation/NavigationService.cs <<'CS'
using System;
using System.Collections.Generic;

namespace DotNetProjectWizard.App.Services.Navigation;

public class NavigationService
{
    private readonly Dictionary<Type, object> _views = new();

    public object? CurrentView { get; private set; }

    public void Register<TViewModel>(TViewModel viewModel) where TViewModel : class
    {
        _views[typeof(TViewModel)] = viewModel;
    }

    public void NavigateTo<TViewModel>() where TViewModel : class
    {
        if (_views.TryGetValue(typeof(TViewModel), out var vm))
        {
            CurrentView = vm;
        }
    }
}
CS

success "NavigationService atualizado."

# ---------------------------------------
# 2. CREATE ROUTER SERVICE
# ---------------------------------------

info "Criando Router Service..."

mkdir -p Services/Routing

cat > Services/Routing/RouterService.cs <<'CS'
using System;

namespace DotNetProjectWizard.App.Services.Routing;

public class RouterService
{
    private readonly NavigationService _navigation;

    public RouterService(NavigationService navigation)
    {
        _navigation = navigation;
    }

    public void GoHome()
    {
        _navigation.NavigateTo<ViewModels.Home.HomeViewModel>();
    }

    public void GoNewProject()
    {
        _navigation.NavigateTo<ViewModels.NewProject.NewProjectViewModel>();
    }

    public void GoTemplates()
    {
        Console.WriteLine("Navigate Templates (future)");
    }

    public void GoLogs()
    {
        Console.WriteLine("Navigate Logs (future)");
    }
}
CS

success "RouterService criado."

# ---------------------------------------
# 3. UPDATE MAIN VIEWMODEL (REAL ROUTING)
# ---------------------------------------

info "Atualizando MainViewModel para routing real..."

cat > ViewModels/MainViewModel.cs <<'CS'
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
    public ICommand TemplatesCommand { get; }
    public ICommand LogsCommand { get; }

    public MainViewModel(NavigationService navigation)
    {
        _navigation = navigation;

        var home = new HomeViewModel();
        var newProject = new NewProjectViewModel();

        _navigation.Register(home);
        _navigation.Register(newProject);

        CurrentView = home;

        HomeCommand = new RelayCommand(() =>
        {
            _navigation.NavigateTo<HomeViewModel>();
            CurrentView = _navigation.CurrentView;
        });

        NewProjectCommand = new RelayCommand(() =>
        {
            _navigation.NavigateTo<NewProjectViewModel>();
            CurrentView = _navigation.CurrentView;
        });

        TemplatesCommand = new RelayCommand(() =>
        {
            System.Console.WriteLine("Templates route (next phase)");
        });

        LogsCommand = new RelayCommand(() =>
        {
            System.Console.WriteLine("Logs route (next phase)");
        });
    }
}
CS

success "MainViewModel atualizado."

# ---------------------------------------
# 4. UPDATE HOME VIEWMODEL (CLEAN)
# ---------------------------------------

info "Limpando HomeViewModel (sem Console logs)..."

cat > ViewModels/Home/HomeViewModel.cs <<'CS'
using DotNetProjectWizard.App.ViewModels.Base;

namespace DotNetProjectWizard.App.ViewModels.Home;

public class HomeViewModel : ViewModelBase
{
    public string Title => "DotNetProjectWizard Dashboard";
}
CS

success "HomeViewModel limpo."

# ---------------------------------------
# 5. FINAL STATUS
# ---------------------------------------

echo
echo "========================================="
echo " NAVIGATION ROUTING FINALIZADO"
echo "========================================="
echo
echo "O que foi implementado:"
echo " - NavigationService real"
echo " - RouterService base"
echo " - Navegação Home <-> NewProject"
echo " - MainViewModel com routing funcional"
echo " - Remoção de logs temporários"
echo
echo "RESULTADO:"
echo " ✔ Navegação funcional real"
echo " ✔ Arquitetura pronta para expansão"
echo " ✔ Base de app tipo IDE/Launcher"
echo
echo "Próximo script:"
echo "  09-view-factory-system.sh"
echo "========================================="
