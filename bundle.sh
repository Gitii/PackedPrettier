#!/usr/bin/env bash

set -e

if [[ -z "$1" ]]; then
    echo "First argument must be the build number"
    exit 1
fi

VERSION_NUMBER="$1"

if [[ ! -f ./packed/version ]]; then
    echo "Pack prettier first!"
    exit 1
fi

dotnet pack -c Release /p:Version="$VERSION_NUMBER"
