#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 07 - Dashboard Actions (Interactive UI)
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/logger.sh"

info "Iniciando Dashboard Actions..."

cd "$APP_PATH"

# ---------------------------------------
# 1. UPDATE HOME VIEW (CLICKABLE CARDS)
# ---------------------------------------

info "Transformando cards em botões clicáveis..."

cat > Views/Home/HomeView.axaml <<'XAML'
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.Views.Home.HomeView">

    <Grid RowDefinitions="Auto,*" Margin="20">

        <StackPanel>
            <TextBlock Text="DotNetProjectWizard"
                       FontSize="28"
                       FontWeight="Bold"/>

            <TextBlock Text="Crie e gerencie projetos .NET rapidamente"
                       Opacity="0.7"
                       Margin="0,5,0,20"/>
        </StackPanel>

        <UniformGrid Grid.Row="1" Columns="2">

            <!-- NEW PROJECT -->
            <Button Command="{Binding NewProjectCommand}"
                    Margin="10"
                    Background="#252537">

                <StackPanel>
                    <TextBlock Text="📦 New Project"
                               FontSize="18"
                               FontWeight="Bold"/>

                    <TextBlock Text="Criar novo projeto .NET"
                               Opacity="0.7"/>
                </StackPanel>

            </Button>

            <!-- TEMPLATES -->
            <Button Command="{Binding TemplatesCommand}"
                    Margin="10"
                    Background="#252537">

                <StackPanel>
                    <TextBlock Text="⚙ Templates"
                               FontSize="18"
                               FontWeight="Bold"/>

                    <TextBlock Text="Gerenciar templates"
                               Opacity="0.7"/>
                </StackPanel>

            </Button>

            <!-- EXTENSIONS -->
            <Button Command="{Binding ExtensionsCommand}"
                    Margin="10"
                    Background="#252537">

                <StackPanel>
                    <TextBlock Text="🧩 Extensions"
                               FontSize="18"
                               FontWeight="Bold"/>

                    <TextBlock Text="Plugins e extensões"
                               Opacity="0.7"/>
                </StackPanel>

            </Button>

            <!-- LOGS -->
            <Button Command="{Binding LogsCommand}"
                    Margin="10"
                    Background="#252537">

                <StackPanel>
                    <TextBlock Text="📊 Logs"
                               FontSize="18"
                               FontWeight="Bold"/>

                    <TextBlock Text="Visualizar logs"
                               Opacity="0.7"/>
                </StackPanel>

            </Button>

        </UniformGrid>

    </Grid>

</UserControl>
XAML

success "HomeView atualizada com ações."

# ---------------------------------------
# 2. UPDATE HOME VIEWMODEL
# ---------------------------------------

info "Criando comandos do dashboard..."

cat > ViewModels/Home/HomeViewModel.cs <<'CS'
using System.Windows.Input;
using DotNetProjectWizard.App.ViewModels.Base;
using DotNetProjectWizard.App.Commands;

namespace DotNetProjectWizard.App.ViewModels.Home;

public class HomeViewModel : ViewModelBase
{
    public ICommand NewProjectCommand { get; }
    public ICommand TemplatesCommand { get; }
    public ICommand ExtensionsCommand { get; }
    public ICommand LogsCommand { get; }

    public HomeViewModel()
    {
        NewProjectCommand = new RelayCommand(() =>
        {
            System.Console.WriteLine("New Project clicked");
        });

        TemplatesCommand = new RelayCommand(() =>
        {
            System.Console.WriteLine("Templates clicked");
        });

        ExtensionsCommand = new RelayCommand(() =>
        {
            System.Console.WriteLine("Extensions clicked");
        });

        LogsCommand = new RelayCommand(() =>
        {
            System.Console.WriteLine("Logs clicked");
        });
    }
}
CS

success "HomeViewModel atualizado."

# ---------------------------------------
# 3. OPTIONAL NAVIGATION HOOK PREP
# ---------------------------------------

info "Preparando estrutura de navegação futura..."

mkdir -p Services/Actions

cat > Services/Actions/DashboardActions.cs <<'CS'
namespace DotNetProjectWizard.App.Services.Actions;

public static class DashboardActions
{
    public static void OpenNewProject()
    {
        System.Console.WriteLine("OPEN NEW PROJECT FLOW");
    }

    public static void OpenTemplates()
    {
        System.Console.WriteLine("OPEN TEMPLATES FLOW");
    }

    public static void OpenExtensions()
    {
        System.Console.WriteLine("OPEN EXTENSIONS FLOW");
    }

    public static void OpenLogs()
    {
        System.Console.WriteLine("OPEN LOGS VIEW");
    }
}
CS

success "DashboardActions criado."

# ---------------------------------------
# 4. FINAL STATUS
# ---------------------------------------

echo
echo "========================================="
echo " DASHBOARD ACTIONS FINALIZADO"
echo "========================================="
echo
echo "O que mudou:"
echo " - Cards agora são clicáveis"
echo " - Commands MVVM funcionando"
echo " - Base para navegação real"
echo " - Estrutura de ações separada"
echo
echo "Próximo script:"
echo "  08-navigation-routing.sh"
echo "========================================="
