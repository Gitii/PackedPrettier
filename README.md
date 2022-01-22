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

1. Install extension [RunOnSave: A Visual Studio extension that can run commands on files when they're saved.](https://github.com/waf/RunOnSave)

2. Create a`.onsaveconfig` with this content:
   
   ```textile
   [*.{js,ts,css,less,scss,vue,json,gql,md}]
   command = dotnet
   arguments = pprettier --write "{file}"
   ```

When you save a file in VS, `prettier` will reformat it

# Supported Framework & Platforms

* .Net Standard 2.1

* .Net 5

* .Net 6

on the platforms

* Windows x64

* Linux x64



# Found a bug? Have a suggestion?

Please [create an issue](https://github.com/Gitii/PackedPrettier/issues).

Pull requests are always welcome :heart_eyes:

## License

This software is released under the [MIT License](https://opensource.org/licenses/MIT).
