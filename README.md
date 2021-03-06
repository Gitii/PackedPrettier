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

```shell
dotnet new tool-manifest # if PackedPrettier is your first tool
dotnet tool install PackedPrettier # will take a few seconds
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

# Plugins

By default, two plugins are included (always the latest version at time of compilation of `prettier`):

-   [prettier/plugin-xml: Prettier XML plugin](https://github.com/prettier/plugin-xml)

-   [prettier-plugin-sh](https://github.com/rx-ts/prettier/tree/master/packages/sh)

They aren't used by default. You need to tell `prettier` where to find them.

Because the plugins are part of the packed `prettier` binary, the files are stored in a virtual filesystem.

For Windows that's `C:\snapshot\node_modules` and `/snapshot/node_modules` for unix systems.

So if you want to load `prettier/plugin-xml`, then you need to write:

```shell
dotnet pprettier --write <file path> --plugin=/snapshot/node_modules/@prettier/plugin-xml
```

To make this portable, `PackedPrettier` will replace `<NodeModulesPath>` at runtime with the correct path:

```shell
dotnet pprettier --write <file path> --plugin=<NodeModulesPath>/@prettier/plugin-xml
```

This will work on any operating system.

Example with `test.xml`:

```shell
dotnet pprettier --write test.xml --plugin=<NodeModulesPath>/@prettier/plugin-xml
```

| Plugin                 | File types                                                | Lookup Path                              |
| ---------------------- | --------------------------------------------------------- | ---------------------------------------- |
| `prettier-plugin-sh`   | shellscript, Dockerfile, gitignore, dotenv and many more! | `<NodeModulesPath>/prettier-plugin-sh`   |
| `@prettier/plugin-xml` | xml                                                       | `<NodeModulesPath>/@prettier/plugin-xml` |

## Custom `.onsaveconfig` entries

```
[*.{xml,csproj,xaml,appxmanifest,props,wapproj}]
command = dotnet
arguments = pprettier --write "{file}" --plugin "<NodeModulesPath>/@prettier/plugin-xml" --parser "xml"

[*.sh]
command = dotnet
arguments = pprettier --write "{file}" --plugin "<NodeModulesPath>/prettier-plugin-sh"
```

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

-   .Net Core 3.1

-   .Net 5

-   .Net 6

# Found a bug? Have a suggestion?

Please [create an issue](https://github.com/Gitii/PackedPrettier/issues).

Pull requests are always welcome :heart_eyes:

## License

This software is released under the [MIT License](https://opensource.org/licenses/MIT).
