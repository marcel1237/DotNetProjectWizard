#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 06 - Home UI Polish (Dashboard Upgrade)
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/logger.sh"

info "Iniciando Home UI Polish..."

cd "$APP_PATH"

# ---------------------------------------
# 1. UPDATE HOME VIEW (DASHBOARD STYLE)
# ---------------------------------------

info "Atualizando HomeView..."

cat > Views/Home/HomeView.axaml <<'XAML'
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.Views.Home.HomeView">

    <Grid RowDefinitions="Auto,*" Margin="20">

        <!-- HEADER -->
        <StackPanel>
            <TextBlock Text="DotNetProjectWizard"
                       FontSize="28"
                       FontWeight="Bold"/>

            <TextBlock Text="Crie projetos .NET rapidamente com templates inteligentes"
                       Opacity="0.7"
                       Margin="0,5,0,20"/>
        </StackPanel>

        <!-- DASHBOARD CARDS -->
        <UniformGrid Grid.Row="1" Columns="2" Rows="2" Margin="0,10">

            <!-- CARD 1 -->
            <Border Background="#252537"
                    CornerRadius="8"
                    Padding="15"
                    Margin="10">

                <StackPanel>
                    <TextBlock Text="📦 New Project"
                               FontSize="18"
                               FontWeight="Bold"/>

                    <TextBlock Text="Criar um novo projeto .NET com templates"
                               Opacity="0.7"
                               Margin="0,5"/>

                </StackPanel>

            </Border>

            <!-- CARD 2 -->
            <Border Background="#252537"
                    CornerRadius="8"
                    Padding="15"
                    Margin="10">

                <StackPanel>
                    <TextBlock Text="⚙ Templates"
                               FontSize="18"
                               FontWeight="Bold"/>

                    <TextBlock Text="Gerenciar templates de projeto"
                               Opacity="0.7"
                               Margin="0,5"/>

                </StackPanel>

            </Border>

            <!-- CARD 3 -->
            <Border Background="#252537"
                    CornerRadius="8"
                    Padding="15"
                    Margin="10">

                <StackPanel>
                    <TextBlock Text="🧩 Extensions"
                               FontSize="18"
                               FontWeight="Bold"/>

                    <TextBlock Text="Plugins e extensões do sistema"
                               Opacity="0.7"
                               Margin="0,5"/>

                </StackPanel>

            </Border>

            <!-- CARD 4 -->
            <Border Background="#252537"
                    CornerRadius="8"
                    Padding="15"
                    Margin="10">

                <StackPanel>
                    <TextBlock Text="📊 Logs"
                               FontSize="18"
                               FontWeight="Bold"/>

                    <TextBlock Text="Visualizar logs do sistema"
                               Opacity="0.7"
                               Margin="0,5"/>

                </StackPanel>

            </Border>

        </UniformGrid>

    </Grid>

</UserControl>
XAML

success "HomeView atualizada."

# ---------------------------------------
# 2. ADD GLOBAL STYLE SYSTEM
# ---------------------------------------

info "Criando tema base..."

mkdir -p Themes

cat > Themes/BaseTheme.axaml <<'XAML'
<ResourceDictionary xmlns="https://github.com/avaloniaui">

    <!-- COLORS -->
    <Color x:Key="Background">#1E1E2E</Color>
    <Color x:Key="CardBackground">#252537</Color>
    <Color x:Key="Accent">#7C3AED</Color>

    <!-- STYLES -->
    <Style Selector="TextBlock">
        <Setter Property="Foreground" Value="White"/>
    </Style>

    <Style Selector="Button">
        <Setter Property="Background" Value="#2D2D44"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="Padding" Value="8"/>
        <Setter Property="CornerRadius" Value="6"/>
    </Style>

    <Style Selector="Button:pointerover">
        <Setter Property="Background" Value="#3A3A55"/>
    </Style>

</ResourceDictionary>
XAML

success "Tema base criado."

# ---------------------------------------
# 3. REGISTER THEME IN APP
# ---------------------------------------

info "Atualizando App.axaml..."

cat > App.axaml <<'XAML'
<Application xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.App">

    <Application.Styles>

        <FluentTheme Mode="Dark"/>

        <StyleInclude Source="avares://DotNetProjectWizard.App/Themes/BaseTheme.axaml"/>

    </Application.Styles>

</Application>
XAML

success "Theme registrado."

# ---------------------------------------
# 4. FINAL STATUS
# ---------------------------------------

echo
echo "========================================="
echo " HOME UI POLISH FINALIZADO"
echo "========================================="
echo
echo "Melhorias:"
echo " - Dashboard estilo IDE"
echo " - Cards UI"
echo " - Tema escuro customizado"
echo " - UI mais moderna"
echo
echo "Próximo script:"
echo "  07-dashboard-actions.sh"
echo "========================================="
