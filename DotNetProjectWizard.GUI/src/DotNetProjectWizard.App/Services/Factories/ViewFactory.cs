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
