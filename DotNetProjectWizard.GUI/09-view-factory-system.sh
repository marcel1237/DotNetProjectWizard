#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 09 - View Factory System
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/logger.sh"

info "Iniciando View Factory System..."

cd "$APP_PATH"

# ---------------------------------------
# 1. VIEW FACTORY CORE
# ---------------------------------------

info "Criando ViewFactory..."

mkdir -p Services/Factories

cat > Services/Factories/ViewFactory.cs <<'CS'
using System;
using System.Collections.Generic;
using Avalonia.Controls;

namespace DotNetProjectWizard.App.Services.Factories;

public class ViewFactory
{
    private readonly Dictionary<Type, Func<Control>> _map = new();

    public void Register<TViewModel, TView>()
        where TView : Control, new()
    {
        _map[typeof(TViewModel)] = () => new TView();
    }

    public Control Create(object viewModel)
    {
        var type = viewModel.GetType();

        if (_map.TryGetValue(type, out var factory))
        {
            var view = factory();
            view.DataContext = viewModel;
            return view;
        }

        return new TextBlock
        {
            Text = $"View not found for {type.Name}"
        };
    }
}
CS

success "ViewFactory criado."

# ---------------------------------------
# 2. UPDATE NAVIGATION SERVICE (FACTORY BASED)
# ---------------------------------------

info "Atualizando NavigationService para usar Factory..."

cat > Services/Navigation/NavigationService.cs <<'CS'
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
CS

success "NavigationService atualizado."

# ---------------------------------------
# 3. CREATE VIEW REGISTRY
# ---------------------------------------

info "Criando ViewRegistry..."

mkdir -p Services/Registry

cat > Services/Registry/ViewRegistry.cs <<'CS'
using DotNetProjectWizard.App.Services.Factories;
using DotNetProjectWizard.App.ViewModels.Home;
using DotNetProjectWizard.App.Views.Home;
using DotNetProjectWizard.App.ViewModels.NewProject;
using DotNetProjectWizard.App.Views.NewProject;

namespace DotNetProjectWizard.App.Services.Registry;

public static class ViewRegistry
{
    public static void RegisterAll(ViewFactory factory)
    {
        factory.Register<HomeViewModel, HomeView>();
        factory.Register<NewProjectViewModel, NewProjectView>();
    }
}
CS

success "ViewRegistry criado."

# ---------------------------------------
# 4. CREATE NEW PROJECT VIEW (IF NOT EXISTS)
# ---------------------------------------

mkdir -p Views/NewProject

cat > Views/NewProject/NewProjectView.axaml <<'XAML'
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.Views.NewProject.NewProjectView">

    <StackPanel Margin="20">

        <TextBlock Text="Create New Project"
                   FontSize="24"
                   FontWeight="Bold"/>

        <TextBlock Text="Wizard coming soon..."
                   Opacity="0.7"
                   Margin="0,10"/>

    </StackPanel>

</UserControl>
XAML

cat > Views/NewProject/NewProjectView.axaml.cs <<'CS'
using Avalonia.Controls;

namespace DotNetProjectWizard.App.Views.NewProject;

public partial class NewProjectView : UserControl
{
    public NewProjectView()
    {
        InitializeComponent();
    }
}
CS

success "NewProjectView criada."

# ---------------------------------------
# 5. FIX NAVIGATION SERVICE IN MAINVM
# ---------------------------------------

info "Atualizando MainViewModel para Factory Navigation..."

cat > ViewModels/MainViewModel.cs <<'CS'
using System.Windows.Input;
using DotNetProjectWizard.App.ViewModels.Base;
using DotNetProjectWizard.App.Commands;
using DotNetProjectWizard.App.ViewModels.Home;
using DotNetProjectWizard.App.ViewModels.NewProject;
using DotNetProjectWizard.App.Services.Navigation;

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
CS

success "MainViewModel atualizado."

# ---------------------------------------
# 6. FINAL STATUS
# ---------------------------------------

echo
echo "========================================="
echo " VIEW FACTORY SYSTEM FINALIZADO"
echo "========================================="
echo
echo "Implementado:"
echo " - ViewFactory (core)"
echo " - ViewRegistry"
echo " - NavigationService baseado em factory"
echo " - NewProjectView adicionada"
echo " - Arquitetura extensível pronta"
echo
echo "RESULTADO:"
echo " ✔ Sistema pronto para escalar como framework"
echo " ✔ Views desacopladas de ViewModels"
echo " ✔ Base para plugin system futuro"
echo
echo "Próximo script:"
echo "  10-di-container-light.sh"
echo "========================================="
