using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using CliWrap;

namespace PackedPrettier;

internal class Program
{
    static Task<int> Main(string[] args)
    {
        var prettierCLi = GetPlatformPrettier(AppContext.BaseDirectory);

        return ExecutePrettierAsync(prettierCLi, args.Length > 0 ? args : new[] { "--help" });
    }

    private static async Task<int> ExecutePrettierAsync(string prettierCLi, string[] args)
    {
        var stdOut = Console.OpenStandardOutput();
        var stdErr = Console.OpenStandardError();
        var stdIn = Console.OpenStandardInput();

        var result = await Cli.Wrap(prettierCLi)
            .WithArguments(args)
            .WithValidation(CommandResultValidation.None)
            .WithStandardOutputPipe(PipeTarget.ToStream(stdOut))
            .WithStandardErrorPipe(PipeTarget.ToStream(stdErr))
            .WithStandardInputPipe(PipeSource.FromStream(stdIn, true))
            .ExecuteAsync()
            .ConfigureAwait(false);

        return result.ExitCode;
    }

    private static string GetPlatformPrettier(string baseDirectory)
    {
        if (!Environment.Is64BitOperatingSystem)
        {
            throw new PlatformNotSupportedException(
                "Only 64bit operating systems are supported."
            );
        }

        switch (Environment.OSVersion.Platform)
        {
            case PlatformID.Win32S:
            case PlatformID.Win32Windows:
            case PlatformID.Win32NT:
            case PlatformID.WinCE:
                return Path.Join(baseDirectory, "packed", "win-x64", "prettier.exe");
            case PlatformID.Unix:
                return Path.Join(baseDirectory, "packed", "linux-x64", "prettier");
            case PlatformID.Xbox:
            case PlatformID.MacOSX:
            default:
                throw new PlatformNotSupportedException(
                    $"Platform {Environment.OSVersion.Platform} is not supported."
                );
        }
    }
}
