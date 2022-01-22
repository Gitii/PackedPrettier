using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using CliWrap;

#pragma warning disable IDE0161 // Convert to file-scoped namespace
namespace PackedPrettier
#pragma warning restore IDE0161 // Convert to file-scoped namespace
{
    internal class Program
    {
        static Task<int> Main(string[] args)
        {
            var prettierCLi = GetPlatformPrettier(AppContext.BaseDirectory);

            var variables = GetVariables();

            var expandedArgs = ExpandArgs(args, variables);

            return ExecutePrettierAsync(prettierCLi, expandedArgs);
        }

        private static IReadOnlyList<(string key, string value)> GetVariables()
        {
            switch (Environment.OSVersion.Platform)
            {
                case PlatformID.Win32S:
                case PlatformID.Win32Windows:
                case PlatformID.Win32NT:
                case PlatformID.WinCE:
                    return new List<(string key, string value)>()
                    {
                        ("<NodeModulesPath>", "C:\\snapshot\\node_modules"),
                    };
                case PlatformID.Unix:
                    return new List<(string key, string value)>() { ("<NodeModulesPath>", "/snapshot/node_modules") };
                case PlatformID.Xbox:
                case PlatformID.MacOSX:
                default:
                    throw new PlatformNotSupportedException(
                        $"Platform {Environment.OSVersion.Platform} is not supported."
                    );
            }
        }

        private static string[] ExpandArgs(
            string[] args,
            IReadOnlyList<(string key, string value)> variables
        )
        {
            return args.Select(
                    (arg) =>
                        variables.Aggregate(
                            arg,
                            (current, keyValue) => current.Replace(keyValue.key, keyValue.value)
                        )
                )
                .ToArray();
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
}
