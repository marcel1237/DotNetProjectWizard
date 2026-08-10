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
