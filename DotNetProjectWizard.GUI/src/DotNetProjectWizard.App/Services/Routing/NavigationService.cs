namespace DotNetProjectWizard.App.Services.Routing
{
    public class NavigationService
    {
        // compatibilidade com RouterService
        public void NavigateTo(string route)
        {
            System.Console.WriteLine($"NavigateTo -> {route}");
        }

        // fallback antigo
        public void Navigate(string route)
        {
            NavigateTo(route);
        }
    }
}
