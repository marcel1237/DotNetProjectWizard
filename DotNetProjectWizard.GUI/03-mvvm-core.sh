#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 03 - MVVM Core Bootstrap (.slnx) FIXED
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"

LIB="$PROJECT_ROOT/lib"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

source "$LIB/common.sh"
source "$LIB/filesystem.sh"
source "$LIB/dotnet.sh"
source "$LIB/logger.sh"

info "Iniciando MVVM Core Bootstrap..."

cd "$APP_PATH"

# ---------------------------
# STRUCTURE
# ---------------------------

info "Criando estrutura MVVM..."

mkdir -p ViewModels/Base
mkdir -p Views/Base
mkdir -p Services/Navigation
mkdir -p Services/Interfaces
mkdir -p Commands
mkdir -p Models
mkdir -p Resources
mkdir -p Themes

success "Estrutura MVVM criada."

# ---------------------------
# VIEWMODEL BASE
# ---------------------------

cat > ViewModels/Base/ViewModelBase.cs <<'CS'
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace DotNetProjectWizard.App.ViewModels.Base;

public abstract class ViewModelBase : INotifyPropertyChanged
{
    public event PropertyChangedEventHandler? PropertyChanged;

    protected void OnPropertyChanged([CallerMemberName] string? name = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
    }

    protected bool SetProperty<T>(ref T field, T value, [CallerMemberName] string? name = null)
    {
        if (Equals(field, value)) return false;
        field = value;
        OnPropertyChanged(name);
        return true;
    }
}
CS

success "ViewModelBase criado."

# ---------------------------
# RELAY COMMAND
# ---------------------------

cat > Commands/RelayCommand.cs <<'CS'
using System;
using System.Windows.Input;

namespace DotNetProjectWizard.App.Commands;

public class RelayCommand : ICommand
{
    private readonly Action _execute;
    private readonly Func<bool>? _canExecute;

    public RelayCommand(Action execute, Func<bool>? canExecute = null)
    {
        _execute = execute;
        _canExecute = canExecute;
    }

    public event EventHandler? CanExecuteChanged;

    public bool CanExecute(object? parameter) => _canExecute?.Invoke() ?? true;

    public void Execute(object? parameter) => _execute();

    public void RaiseCanExecuteChanged()
        => CanExecuteChanged?.Invoke(this, EventArgs.Empty);
}
CS

success "RelayCommand criado."

# ---------------------------
# NAVIGATION SERVICE
# ---------------------------

cat > Services/Interfaces/INavigationService.cs <<'CS'
namespace DotNetProjectWizard.App.Services.Interfaces;

public interface INavigationService
{
    void NavigateTo<TViewModel>() where TViewModel : class;
    object? CurrentView { get; }
}
CS

cat > Services/Navigation/NavigationService.cs <<'CS'
using System;
using System.Collections.Generic;
using DotNetProjectWizard.App.Services.Interfaces;

namespace DotNetProjectWizard.App.Services.Navigation;

public class NavigationService : INavigationService
{
    private readonly Dictionary<Type, object> _viewModels = new();

    public object? CurrentView { get; private set; }

    public void Register<T>(T viewModel) where T : class
    {
        _viewModels[typeof(T)] = viewModel;
    }

    public void NavigateTo<TViewModel>() where TViewModel : class
    {
        if (_viewModels.TryGetValue(typeof(TViewModel), out var vm))
        {
            CurrentView = vm;
        }
    }
}
CS

success "NavigationService criado."

# ---------------------------
# MAIN VIEWMODEL
# ---------------------------

cat > ViewModels/MainViewModel.cs <<'CS'
using System.Windows.Input;
using DotNetProjectWizard.App.ViewModels.Base;
using DotNetProjectWizard.App.Commands;
using DotNetProjectWizard.App.Services.Interfaces;

namespace DotNetProjectWizard.App.ViewModels;

public class MainViewModel : ViewModelBase
{
    private readonly INavigationService _navigation;
    private object? _currentView;

    public object? CurrentView
    {
        get => _currentView;
        set => SetProperty(ref _currentView, value);
    }

    public ICommand ShowHomeCommand { get; }
    public ICommand ShowNewProjectCommand { get; }

    public MainViewModel(INavigationService navigation)
    {
        _navigation = navigation;

        ShowHomeCommand = new RelayCommand(() =>
        {
            _navigation.NavigateTo<HomeViewModel>();
            CurrentView = _navigation.CurrentView;
        });

        ShowNewProjectCommand = new RelayCommand(() =>
        {
            _navigation.NavigateTo<NewProjectViewModel>();
            CurrentView = _navigation.CurrentView;
        });
    }
}
CS

success "MainViewModel criado."

# ---------------------------
# VIEW BASE
# ---------------------------

cat > Views/Base/ViewBase.axaml <<'XAML'
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.Views.Base.ViewBase">
</UserControl>
XAML

success "ViewBase criada."

# ---------------------------
# FINAL
# ---------------------------

echo
echo "========================================="
echo " MVVM CORE FINALIZADO (FIXED)"
echo "========================================="
echo
echo "Próximo script:"
echo "  04-ui-shell.sh"
echo "========================================="
