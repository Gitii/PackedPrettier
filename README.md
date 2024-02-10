# PackedPrettier

The opinionated code formatter Prettier packed as dotnet tool.

# What is `prettier`?

> Prettier is an opinionated code formatter. It enforces a consistent style by parsing your code and re-printing it with its own rules that take the maximum line length into account, wrapping code when necessary.

[GitHub - prettier/prettier: Prettier is an opinionated code formatter.](https://github.com/prettier/prettier)

It is written in `javascript` and requires `node` to run.

# What is `PackedPrettier`?

`PackedPrettier` packs `prettier` in an executable for various platforms.

Including `node`.

You can install it using `dotnet tool install`, both as global and local tool.

# Getting started

## Installation

Install as local `dotnet tool`:

1. If you haven't used any other dotnet tools yet, create a tool manifest first:
   ```shell
   dotnet new tool-manifest
   ```
2. Install PackedPrettier 
   ```shell
   dotnet tool install PackedPrettier
   ```


## How to use

In the terminal:

```shell
dotnet pprettier --help
```

> :exclamation: The command is named `pprettier` for brevity and internally `prettier` is executed.

In Visual Studio

1. Install [RunOnSave: A Visual Studio extension that can run commands on files when they're saved.](https://github.com/waf/RunOnSave)

2. Create a `.onsaveconfig` with this content:

    ```textile
    [*.{js,jsx,ts,tsx,css,less,scss,vue,json,gql,md}]
    command = dotnet
    arguments = pprettier --write "{file}"
    ```

When you save a file in VS, `prettier` will reformat it

# Migration from v2 to v3

Prettier has migrated to es modules. This means that the `prettier` package is no longer compatible with `pkg` and `PackedPrettier` v2. Previously the `pkg` package has been used to pack `prettier` into an executable. This is no longer possible. The new version of `PackedPrettier` uses a different approach to pack `prettier` into an executable: `deno`. `deno` compiles `prettier` into an single executable. This executable is then used by the `PackedPrettier` loader to run `prettier` in the same way as before.

Deno does not allow to import modules at runtime, see https://github.com/denoland/deno/issues/8655 for details.
That means but plugins and javascript config files (for example `prettier.config.js`) are not supported anymore.

If this is a showstopper for you, please open an issue and we can discuss a solution. A potential solution could be to use `bun` to pack `prettier`. But `bun` has no stable release for windows yet.

I still consider the windows build of `PackedPrettier` as experimental. If you encounter any issues, please open an issue.


# Restrictions

Compared to run `prettier` with `node` there are some restrictions:
* Plugins are not supported (see https://github.com/denoland/deno/issues/8655 for details)
* Javascript config files (for example `prettier.config.js`) are not supported
* All restrictions of `deno` apply

This is because `deno` does not allow to import modules at runtime.
If this is a showstopper for you, please open an issue and we can discuss a solution. A potential solution could be to use `bun` to pack `prettier`. But `bun` has no stable release for windows yet.

# What about C# files (_.cs_)?

There is a (sort of) port of `prettier` that supports `cs` files:

Checkout [belav/csharpier: an opinionated code formatter for c#.](https://github.com/belav/csharpier) and install it as `dotnet tool`. Then add this to your `.onsaveconfig` file:

```
[*.cs]
command = dotnet
arguments = csharpier "{file}"
```

# Supported Platforms of `PackedPrettier`

`prettier` is compiled for

-   Windows x64

-   Linux x64

and the loader requires either

-   .Net 6

-   .Net 7

-   .Net 8

> :exclamation: Support for .NET Core 3.1 and .NET 5 has been dropped because they are out of support.

# Mac OS support

This is not possible because executable has to be signed (with either an adhoc signature) or an Apple Developer ID.
Checkout the [official `pkg` readme](https://github.com/vercel/pkg#targets) for historical details. The same restrictions apply to `deno`, too.


# Found a bug? Have a suggestion?

Please [create an issue](https://github.com/Gitii/PackedPrettier/issues).

Pull requests are always welcome :heart_eyes:

## License

This software is released under the [MIT License](https://opensource.org/licenses/MIT).
