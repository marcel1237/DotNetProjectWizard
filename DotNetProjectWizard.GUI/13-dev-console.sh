#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 13 - Internal Dev Console (Engine Log System)
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/logger.sh"

info "Iniciando Dev Console System..."

cd "$APP_PATH"

# ---------------------------------------
# 1. ENGINE LOGGER CORE
# ---------------------------------------

info "Criando EngineLogger..."

mkdir -p Infrastructure/Logging

cat > Infrastructure/Logging/EngineLogger.cs <<'CS'
using System;
using System.Collections.Generic;

namespace DotNetProjectWizard.App.Infrastructure.Logging;

public enum LogLevel
{
    Info,
    Warning,
    Error,
    Debug
}

public class LogEntry
{
    public DateTime Time { get; set; } = DateTime.Now;
    public LogLevel Level { get; set; }
    public string Message { get; set; } = "";
}

public class EngineLogger
{
    private readonly List<LogEntry> _logs = new();

    public event Action<LogEntry>? OnLog;

    public IReadOnlyList<LogEntry> Logs => _logs;

    public void Log(string message, LogLevel level = LogLevel.Info)
    {
        var entry = new LogEntry
        {
            Message = message,
            Level = level,
            Time = DateTime.Now
        };

        _logs.Add(entry);
        OnLog?.Invoke(entry);
    }

    public void Info(string msg) => Log(msg, LogLevel.Info);
    public void Warn(string msg) => Log(msg, LogLevel.Warning);
    public void Error(string msg) => Log(msg, LogLevel.Error);
    public void Debug(string msg) => Log(msg, LogLevel.Debug);
}
CS

success "EngineLogger criado."

# ---------------------------------------
# 2. DEV CONSOLE VIEWMODEL
# ---------------------------------------

info "Criando ConsoleViewModel..."

mkdir -p ViewModels/Console

cat > ViewModels/Console/ConsoleViewModel.cs <<'CS'
using System.Collections.ObjectModel;
using DotNetProjectWizard.App.ViewModels.Base;
using DotNetProjectWizard.App.Infrastructure.Logging;

namespace DotNetProjectWizard.App.ViewModels.Console;

public class ConsoleViewModel : ViewModelBase
{
    public ObservableCollection<LogEntry> Logs { get; } = new();

    public ConsoleViewModel(EngineLogger logger)
    {
        logger.OnLog += entry =>
        {
            Logs.Add(entry);
        };

        logger.Info("Dev Console initialized");
    }
}
CS

success "ConsoleViewModel criado."

# ---------------------------------------
# 3. DEV CONSOLE VIEW
# ---------------------------------------

mkdir -p Views/Console

cat > Views/Console/ConsoleView.axaml <<'XAML'
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.Views.Console.ConsoleView">

    <DockPanel Margin="10">

        <TextBlock Text="DEV CONSOLE"
                   FontSize="18"
                   DockPanel.Dock="Top"
                   Margin="0,0,0,10"/>

        <ListBox ItemsSource="{Binding Logs}">

            <ListBox.ItemTemplate>
                <DataTemplate>
                    <StackPanel Orientation="Horizontal">

                        <TextBlock Text="{Binding Time}"
                                   Opacity="0.6"
                                   Margin="0,0,10,0"/>

                        <TextBlock Text="{Binding Level}"
                                   Margin="0,0,10,0"/>

                        <TextBlock Text="{Binding Message}"/>

                    </StackPanel>
                </DataTemplate>
            </ListBox.ItemTemplate>

        </ListBox>

    </DockPanel>

</UserControl>
XAML

cat > Views/Console/ConsoleView.axaml.cs <<'CS'
using Avalonia.Controls;

namespace DotNetProjectWizard.App.Views.Console;

public partial class ConsoleView : UserControl
{
    public ConsoleView()
    {
        InitializeComponent();
    }
}
CS

success "ConsoleView criada."

# ---------------------------------------
# 4. UPDATE VIEW REGISTRY
# ---------------------------------------

info "Registrando Console no ViewRegistry..."

cat > Services/Registry/ViewRegistry.cs <<'CS'
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
CS

success "ViewRegistry atualizado."

# ---------------------------------------
# 5. INJECT LOGGER INTO ENGINE
# ---------------------------------------

info "Integrando EngineLogger no Engine..."

cat > Infrastructure/DI/Engine.cs <<'CS'
using DotNetProjectWizard.App.Services.Navigation;
using DotNetProjectWizard.App.Services.Factories;
using DotNetProjectWizard.App.Services.Registry;
using DotNetProjectWizard.App.Infrastructure.Logging;

namespace DotNetProjectWizard.App.Infrastructure.DI;

public class Engine
{
    public ServiceContainer Services { get; } = new();

    public void Configure()
    {
        var logger = new EngineLogger();
        var factory = new ViewFactory();

        ViewRegistry.RegisterAll(factory);

        Services.AddSingleton(logger);
        Services.AddSingleton(factory);

        Services.AddSingleton(c =>
        {
            var f = c.Get<ViewFactory>();
            return new NavigationService(f);
        });

        logger.Info("Engine initialized");
    }
}
CS

success "Engine integrado com Logger."

# ---------------------------------------
# 6. FINAL STATUS
# ---------------------------------------

echo
echo "========================================="
echo " DEV CONSOLE SYSTEM FINALIZADO"
echo "========================================="
echo
echo "Implementado:"
echo " - EngineLogger global"
echo " - ConsoleView (UI debug)"
echo " - ConsoleViewModel"
echo " - Logs reativos em tempo real"
echo " - Integração no Engine DI"
echo
echo "RESULTADO:"
echo " ✔ Debug interno tipo Unreal/Unity"
echo " ✔ Sistema observável em runtime"
echo " ✔ Base para engine profissional"
echo
echo "Próximo script:"
echo "  14-final-ui-integration.sh"
echo "========================================="
