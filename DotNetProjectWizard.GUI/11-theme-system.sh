#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 11 - Theme System Core
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/logger.sh"

info "Iniciando Theme System..."

cd "$APP_PATH"

# ---------------------------------------
# 1. BASE DESIGN TOKENS
# ---------------------------------------

info "Criando Design Tokens..."

mkdir -p Themes/Tokens

cat > Themes/Tokens/Colors.axaml <<'XAML'
<ResourceDictionary xmlns="https://github.com/avaloniaui">

    <!-- Backgrounds -->
    <Color x:Key="Color.Background.Primary">#1E1E2E</Color>
    <Color x:Key="Color.Background.Secondary">#252537</Color>
    <Color x:Key="Color.Background.Tertiary">#2D2D44</Color>

    <!-- Text -->
    <Color x:Key="Color.Text.Primary">#FFFFFF</Color>
    <Color x:Key="Color.Text.Secondary">#B5B5C3</Color>

    <!-- Accent -->
    <Color x:Key="Color.Accent.Primary">#7C3AED</Color>
    <Color x:Key="Color.Accent.Hover">#9B5CFF</Color>

    <!-- Status -->
    <Color x:Key="Color.Success">#22C55E</Color>
    <Color x:Key="Color.Warning">#F59E0B</Color>
    <Color x:Key="Color.Error">#EF4444</Color>

</ResourceDictionary>
XAML

success "Colors tokens criados."

# ---------------------------------------
# 2. BASE STYLES
# ---------------------------------------

info "Criando Base Styles..."

mkdir -p Themes/Styles

cat > Themes/Styles/BaseStyles.axaml <<'XAML'
<ResourceDictionary xmlns="https://github.com/avaloniaui">

    <!-- TEXT -->
    <Style Selector="TextBlock">
        <Setter Property="Foreground" Value="{DynamicResource Color.Text.Primary}"/>
    </Style>

    <!-- BUTTON -->
    <Style Selector="Button">
        <Setter Property="Background" Value="{DynamicResource Color.Background.Tertiary}"/>
        <Setter Property="Foreground" Value="{DynamicResource Color.Text.Primary}"/>
        <Setter Property="Padding" Value="10"/>
        <Setter Property="CornerRadius" Value="6"/>
        <Setter Property="BorderThickness" Value="0"/>
    </Style>

    <Style Selector="Button:pointerover">
        <Setter Property="Background" Value="{DynamicResource Color.Accent.Primary}"/>
    </Style>

    <!-- CARD STYLE -->
    <Style Selector="Border.card">
        <Setter Property="Background" Value="{DynamicResource Color.Background.Secondary}"/>
        <Setter Property="CornerRadius" Value="10"/>
        <Setter Property="Padding" Value="15"/>
        <Setter Property="Margin" Value="8"/>
    </Style>

</ResourceDictionary>
XAML

success "Base styles criados."

# ---------------------------------------
# 3. DARK THEME ROOT
# ---------------------------------------

info "Criando Dark Theme..."

cat > Themes/DarkTheme.axaml <<'XAML'
<ResourceDictionary xmlns="https://github.com/avaloniaui">

    <ResourceDictionary.MergedDictionaries>

        <ResourceInclude Source="avares://DotNetProjectWizard.App/Themes/Tokens/Colors.axaml"/>
        <ResourceInclude Source="avares://DotNetProjectWizard.App/Themes/Styles/BaseStyles.axaml"/>

    </ResourceDictionary.MergedDictionaries>

</ResourceDictionary>
XAML

success "DarkTheme criado."

# ---------------------------------------
# 4. UPDATE APP AXAML
# ---------------------------------------

info "Atualizando App.axaml para Theme System..."

cat > App.axaml <<'XAML'
<Application xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.App">

    <Application.Styles>

        <FluentTheme Mode="Dark"/>

        <StyleInclude Source="avares://DotNetProjectWizard.App/Themes/DarkTheme.axaml"/>

    </Application.Styles>

</Application>
XAML

success "App.axaml atualizado."

# ---------------------------------------
# 5. UPDATE HOME VIEW USING THEME
# ---------------------------------------

info "Aplicando theme no HomeView..."

cat > Views/Home/HomeView.axaml <<'XAML'
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.Views.Home.HomeView">

    <Grid RowDefinitions="Auto,*" Margin="20">

        <StackPanel>

            <TextBlock Text="DotNetProjectWizard"
                       FontSize="30"
                       FontWeight="Bold"/>

            <TextBlock Text="Enterprise GUI Framework"
                       Foreground="{DynamicResource Color.Text.Secondary}"
                       Margin="0,5,0,20"/>

        </StackPanel>

        <UniformGrid Grid.Row="1" Columns="2">

            <Border Classes="card">
                <StackPanel>
                    <TextBlock Text="📦 New Project" FontSize="18"/>
                    <TextBlock Text="Create .NET applications" Foreground="{DynamicResource Color.Text.Secondary}"/>
                </StackPanel>
            </Border>

            <Border Classes="card">
                <StackPanel>
                    <TextBlock Text="⚙ Templates" FontSize="18"/>
                    <TextBlock Text="Manage project templates" Foreground="{DynamicResource Color.Text.Secondary}"/>
                </StackPanel>
            </Border>

            <Border Classes="card">
                <StackPanel>
                    <TextBlock Text="🧩 Extensions" FontSize="18"/>
                    <TextBlock Text="Plugins system" Foreground="{DynamicResource Color.Text.Secondary}"/>
                </StackPanel>
            </Border>

            <Border Classes="card">
                <StackPanel>
                    <TextBlock Text="📊 Logs" FontSize="18"/>
                    <TextBlock Text="System logs viewer" Foreground="{DynamicResource Color.Text.Secondary}"/>
                </StackPanel>
            </Border>

        </UniformGrid>

    </Grid>

</UserControl>
XAML

success "HomeView atualizado com Theme System."

# ---------------------------------------
# 6. FINAL STATUS
# ---------------------------------------

echo
echo "========================================="
echo " THEME SYSTEM FINALIZADO"
echo "========================================="
echo
echo "Implementado:"
echo " - Design Tokens (Colors)"
echo " - Base Styles (Buttons, Cards, Text)"
echo " - Dark Theme modular"
echo " - App.axaml centralizado"
echo " - Home UI estilizada profissional"
echo
echo "RESULTADO:"
echo " ✔ UI consistente e escalável"
echo " ✔ Base para design system real"
echo " ✔ Preparado para Light/Dark toggle"
echo
echo "Próximo script:"
echo "  12-ui-interactions-polish.sh"
echo "========================================="
