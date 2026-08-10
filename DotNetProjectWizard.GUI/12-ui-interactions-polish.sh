#!/usr/bin/env bash
#
# DotNetProjectWizard GUI
# Phase 1
# Script 12 - UI Interactions Polish (Premium Feel)
#

set -Eeuo pipefail

PROJECT_ROOT="$HOME/DotNetProjectWizard/DotNetProjectWizard.GUI"
SRC="$PROJECT_ROOT/src"
APP="DotNetProjectWizard.App"
APP_PATH="$SRC/$APP"

LIB="$PROJECT_ROOT/lib"

source "$LIB/common.sh"
source "$LIB/logger.sh"

info "Iniciando UI Interactions Polish..."

cd "$APP_PATH"

# ---------------------------------------
# 1. ENHANCED CARD STYLE (HOVER + CLICK)
# ---------------------------------------

info "Melhorando estilos globais..."

mkdir -p Themes/Styles

cat > Themes/Styles/InteractionStyles.axaml <<'XAML'
<ResourceDictionary xmlns="https://github.com/avaloniaui">

    <!-- BASE CARD INTERACTIVE -->
    <Style Selector="Border.card">
        <Setter Property="Background" Value="{DynamicResource Color.Background.Secondary}"/>
        <Setter Property="CornerRadius" Value="12"/>
        <Setter Property="Padding" Value="16"/>
        <Setter Property="Margin" Value="8"/>
        <Setter Property="RenderTransform">
            <ScaleTransform ScaleX="1" ScaleY="1"/>
        </Setter>

        <Style.Animations>

            <!-- HOVER EFFECT -->
            <Animation Duration="0:0:0.15">
                <KeyFrame Cue="0%">
                    <Setter Property="RenderTransform.(ScaleTransform.ScaleX)" Value="1"/>
                    <Setter Property="RenderTransform.(ScaleTransform.ScaleY)" Value="1"/>
                </KeyFrame>

                <KeyFrame Cue="100%">
                    <Setter Property="RenderTransform.(ScaleTransform.ScaleX)" Value="1.03"/>
                    <Setter Property="RenderTransform.(ScaleTransform.ScaleY)" Value="1.03"/>
                </KeyFrame>
            </Animation>

        </Style.Animations>
    </Style>

    <!-- HOVER STATE -->
    <Style Selector="Border.card:pointerover">
        <Setter Property="Background" Value="{DynamicResource Color.Background.Tertiary}"/>
    </Style>

    <!-- BUTTON INTERACTION -->
    <Style Selector="Button">
        <Setter Property="Cursor" Value="Hand"/>
    </Style>

    <Style Selector="Button:pointerover">
        <Setter Property="Opacity" Value="0.9"/>
    </Style>

    <Style Selector="Button:pressed">
        <Setter Property="RenderTransform">
            <ScaleTransform ScaleX="0.97" ScaleY="0.97"/>
        </Setter>
    </Style>

</ResourceDictionary>
XAML

success "Interaction styles criados."

# ---------------------------------------
# 2. UPDATE DARK THEME INCLUDE
# ---------------------------------------

info "Atualizando DarkTheme..."

cat > Themes/DarkTheme.axaml <<'XAML'
<ResourceDictionary xmlns="https://github.com/avaloniaui">

    <ResourceDictionary.MergedDictionaries>

        <ResourceInclude Source="avares://DotNetProjectWizard.App/Themes/Tokens/Colors.axaml"/>
        <ResourceInclude Source="avares://DotNetProjectWizard.App/Themes/Styles/BaseStyles.axaml"/>
        <ResourceInclude Source="avares://DotNetProjectWizard.App/Themes/Styles/InteractionStyles.axaml"/>

    </ResourceDictionary.MergedDictionaries>

</ResourceDictionary>
XAML

success "DarkTheme atualizado."

# ---------------------------------------
# 3. APPLY FIX TO HOME VIEW (VISUAL FEEL)
# ---------------------------------------

info "Aplicando UX polish no HomeView..."

cat > Views/Home/HomeView.axaml <<'XAML'
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DotNetProjectWizard.App.Views.Home.HomeView">

    <Grid RowDefinitions="Auto,*" Margin="24">

        <!-- HEADER -->
        <StackPanel>

            <TextBlock Text="DotNetProjectWizard"
                       FontSize="32"
                       FontWeight="Bold"/>

            <TextBlock Text="Modern .NET GUI Engine"
                       Foreground="{DynamicResource Color.Text.Secondary}"
                       Margin="0,6,0,18"/>

        </StackPanel>

        <!-- DASHBOARD -->
        <UniformGrid Grid.Row="1" Columns="2">

            <Border Classes="card">
                <StackPanel>
                    <TextBlock Text="📦 New Project"
                               FontSize="18"
                               FontWeight="SemiBold"/>
                    <TextBlock Text="Create modern .NET apps"
                               Foreground="{DynamicResource Color.Text.Secondary}"
                               Margin="0,6,0,0"/>
                </StackPanel>
            </Border>

            <Border Classes="card">
                <StackPanel>
                    <TextBlock Text="⚙ Templates"
                               FontSize="18"
                               FontWeight="SemiBold"/>
                    <TextBlock Text="Project templates manager"
                               Foreground="{DynamicResource Color.Text.Secondary}"
                               Margin="0,6,0,0"/>
                </StackPanel>
            </Border>

            <Border Classes="card">
                <StackPanel>
                    <TextBlock Text="🧩 Extensions"
                               FontSize="18"
                               FontWeight="SemiBold"/>
                    <TextBlock Text="Plugin ecosystem"
                               Foreground="{DynamicResource Color.Text.Secondary}"
                               Margin="0,6,0,0"/>
                </StackPanel>
            </Border>

            <Border Classes="card">
                <StackPanel>
                    <TextBlock Text="📊 Logs"
                               FontSize="18"
                               FontWeight="SemiBold"/>
                    <TextBlock Text="System diagnostics"
                               Foreground="{DynamicResource Color.Text.Secondary}"
                               Margin="0,6,0,0"/>
                </StackPanel>
            </Border>

        </UniformGrid>

    </Grid>

</UserControl>
XAML

success "HomeView refinado."

# ---------------------------------------
# 4. FINAL STATUS
# ---------------------------------------

echo
echo "========================================="
echo " UI INTERACTIONS POLISH FINALIZADO"
echo "========================================="
echo
echo "Implementado:"
echo " - Hover animations em cards"
echo " - Click/press feedback"
echo " - Cursor pointer UX"
echo " - Scaling transitions"
echo " - UI mais fluida e premium"
echo
echo "RESULTADO:"
echo " ✔ Sensação de app profissional"
echo " ✔ Interações suaves"
echo " ✔ Base de UX moderna"
echo
echo "Próximo script:"
echo "  13-final-phase-init.sh"
echo "========================================="
