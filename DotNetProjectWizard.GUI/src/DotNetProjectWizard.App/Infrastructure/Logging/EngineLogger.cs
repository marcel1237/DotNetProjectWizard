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
