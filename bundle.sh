#!/usr/bin/env bash

set -e

if [[ -z "$1" ]]; then
    echo "First argument must be the build number"
    exit 1
fi

if [[ -z "$2" ]]; then
    echo "First argument must be the prettier version number"
    exit 1
fi

BUILD_NUMBER="$1"
PRETTIER_VERSION="$2"

dotnet pack -c Release /p:Version="$PRETTIER_VERSION.$BUILD_NUMBER"
