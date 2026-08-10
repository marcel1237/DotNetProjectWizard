#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 10 - Light DI Container (Engine Core)
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/logger.sh"

info "Iniciando Light DI Container..."

cd "$APP_PATH"

# ---------------------------------------
# 1. SERVICE CONTAINER CORE
# ---------------------------------------

info "Criando ServiceContainer..."

mkdir -p Infrastructure/DI

cat > Infrastructure/DI/ServiceContainer.cs <<'CS'
using System;
using System.Collections.Generic;

namespace DotNetProjectWizard.App.Infrastructure.DI;

public class ServiceContainer
{
    private readonly Dictionary<Type, object> _singletons = new();

    private readonly Dictionary<Type, Func<ServiceContainer, object>> _transients = new();

    // REGISTER SINGLETON
    public void AddSingleton<T>(T instance) where T : class
    {
        _singletons[typeof(T)] = instance!;
    }

    public void AddSingleton<T>(Func<ServiceContainer, T> factory) where T : class
    {
        _singletons[typeof(T)] = factory(this)!;
    }

    // REGISTER TRANSIENT
    public void AddTransient<T>(Func<ServiceContainer, T> factory) where T : class
    {
        _transients[typeof(T)] = c => factory(c)!;
    }

    // RESOLVE
    public T Get<T>() where T : class
    {
        var type = typeof(T);

        if (_singletons.TryGetValue(type, out var singleton))
            return (T)singleton;

        if (_transients.TryGetValue(type, out var factory))
            return (T)factory(this);

        throw new Exception($"Service {type.Name} not registered");
    }
}
CS

success "ServiceContainer criado."

# ---------------------------------------
# 2. ENGINE BOOTSTRAP
# ---------------------------------------

info "Criando Engine bootstrap..."

cat > Infrastructure/DI/Engine.cs <<'CS'
using DotNetProjectWizard.App.Services.Navigation;
using DotNetProjectWizard.App.Services.Factories;
using DotNetProjectWizard.App.Services.Registry;

namespace DotNetProjectWizard.App.Infrastructure.DI;

public class Engine
{
    public ServiceContainer Services { get; } = new();

    public void Configure()
    {
        // CORE SERVICES
        var factory = new ViewFactory();
        ViewRegistry.RegisterAll(factory);

        Services.AddSingleton(factory);

        Services.AddSingleton(c =>
        {
            var f = c.Get<ViewFactory>();
            return new NavigationService(f);
        });
    }
}
CS

success "Engine criado."

# ---------------------------------------
# 3. UPDATE APP BOOTSTRAP
# ---------------------------------------

info "Atualizando App.axaml.cs para usar Engine..."

cat > App.axaml.cs <<'CS'
using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;
using DotNetProjectWizard.App.Infrastructure.DI;
using DotNetProjectWizard.App.ViewModels;
using DotNetProjectWizard.App.ViewModels.Home;

namespace DotNetProjectWizard.App;

public partial class App : Application
{
    public override void Initialize()
    {
        AvaloniaXamlLoader.Load(this);
    }

    public override void OnFrameworkInitializationCompleted()
    {
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            var engine = new Engine();
            engine.Configure();

            var navigation = engine.Services.Get<Services.Navigation.NavigationService>();

            var home = new HomeViewModel();

            navigation.NavigateTo(home);

            var mainVM = new MainViewModel(navigation);

            desktop.MainWindow = new MainWindow
            {
                DataContext = mainVM
            };
        }

        base.OnFrameworkInitializationCompleted();
    }
}
CS

success "App bootstrap atualizado."

# ---------------------------------------
# 4. CLEAN MAINVIEWMODEL DEPENDENCY
# ---------------------------------------

info "Refatorando MainViewModel para DI engine..."

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

success "MainViewModel ajustado."

# ---------------------------------------
# 5. FINAL STATUS
# ---------------------------------------

echo
echo "========================================="
echo " LIGHT DI CONTAINER FINALIZADO"
echo "========================================="
echo
echo "Implementado:"
echo " - ServiceContainer (singleton/transient)"
echo " - Engine core"
echo " - DI bootstrap no App"
echo " - ViewFactory integrado"
echo " - NavigationService via container"
echo
echo "RESULTADO:"
echo " ✔ Arquitetura tipo engine"
echo " ✔ Base para plugins futuros"
echo " ✔ App desacoplado de instâncias diretas"
echo
echo "Próximo script:"
echo "  11-theme-system.sh"
echo "========================================="
