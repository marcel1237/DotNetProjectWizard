#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 04 - UI Shell (IDE Layout)
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/dotnet.sh"
source "$LIB/logger.sh"

info "Iniciando UI Shell (IDE Layout)..."

cd "$APP_PATH"

# -------------------------------
# 1. MAIN WINDOW (REPLACE UI)
# -------------------------------

info "Criando MainWindow layout..."

cat > MainWindow.axaml <<'XAML'
<Window xmlns="https://github.com/avaloniaui"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        mc:Ignorable="d"
        x:Class="DotNetProjectWizard.App.MainWindow"
        Width="1100"
        Height="700"
        Title="DotNetProjectWizard">

    <Grid ColumnDefinitions="220,*">

        <!-- SIDEBAR -->
        <Border Background="#1E1E2E">
            <StackPanel>

                <TextBlock Text="DotNetWizard"
                           Margin="15"
                           FontSize="16"
                           Foreground="White"/>

                <Button Content="🏠 Home"
                        Margin="10"
                        Command="{Binding ShowHomeCommand}"/>

                <Button Content="📦 New Project"
                        Margin="10"
                        Command="{Binding ShowNewProjectCommand}"/>

            </StackPanel>
        </Border>

        <!-- CONTENT AREA -->
        <ContentControl Grid.Column="1"
                        Content="{Binding CurrentView}"/>

    </Grid>
</Window>
XAML

success "MainWindow criada."

# -------------------------------
# 2. MAIN WINDOW CODE BEHIND
# -------------------------------

cat > MainWindow.axaml.cs <<'CS'
using Avalonia.Controls;

namespace DotNetProjectWizard.App;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }
}
CS

success "MainWindow code-behind criado."

# -------------------------------
# 3. HOME VIEW
# -------------------------------

mkdir -p Views/Home

cat > Views/Home/HomeView.axaml <<'XAML'
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.Views.Home.HomeView">

    <StackPanel HorizontalAlignment="Center"
                VerticalAlignment="Center">

        <TextBlock Text="DotNetProjectWizard"
                   FontSize="28"
                   HorizontalAlignment="Center"/>

        <TextBlock Text="Welcome to the GUI Wizard"
                   Margin="0,10,0,0"
                   HorizontalAlignment="Center"/>

    </StackPanel>

</UserControl>
XAML

cat > Views/Home/HomeView.axaml.cs <<'CS'
using Avalonia.Controls;

namespace DotNetProjectWizard.App.Views.Home;

public partial class HomeView : UserControl
{
    public HomeView()
    {
        InitializeComponent();
    }
}
CS

success "HomeView criada."

# -------------------------------
# 4. VIEWMODEL HOME
# -------------------------------

mkdir -p ViewModels/Home

cat > ViewModels/Home/HomeViewModel.cs <<'CS'
using DotNetProjectWizard.App.ViewModels.Base;

namespace DotNetProjectWizard.App.ViewModels.Home;

public class HomeViewModel : ViewModelBase
{
    public string Title => "DotNetProjectWizard GUI";
}
CS

success "HomeViewModel criada."

# -------------------------------
# 5. VIEWMODEL NEW PROJECT (PLACEHOLDER)
# -------------------------------

mkdir -p ViewModels/NewProject

cat > ViewModels/NewProject/NewProjectViewModel.cs <<'CS'
using DotNetProjectWizard.App.ViewModels.Base;

namespace DotNetProjectWizard.App.ViewModels.NewProject;

public class NewProjectViewModel : ViewModelBase
{
    public string Title => "Create New Project";
}
CS

success "NewProjectViewModel criada."

# -------------------------------
# 6. SIMPLE VIEW LOCATOR (MINIMO)
# -------------------------------

mkdir -p Services/ViewLocator

cat > Services/ViewLocator/ViewLocator.cs <<'CS'
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
CS

success "ViewLocator criado."

# -------------------------------
# 7. FINAL STATUS
# -------------------------------

echo
echo "========================================="
echo " UI SHELL FINALIZADO"
echo "========================================="
echo
echo "Criado:"
echo " - MainWindow IDE layout"
echo " - Sidebar funcional"
echo " - HomeView"
echo " - HomeViewModel"
echo " - NewProjectViewModel"
echo " - ViewLocator base"
echo
echo "Próximo script:"
echo "  05-navigation-wire.sh"
echo "========================================="
