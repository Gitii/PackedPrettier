#!/usr/bin/env bash

set -e

if [[ -z "$1" ]]; then
    echo "First argument must be the prettier version number"
    exit 1
fi

PRETTIER_VERSION="$1"

# create temp directory
SRC_DIR=$(dirname $(readlink -f "$0"))
DST_DIR="$SRC_DIR/packed"
TEMP_DIR=$(mktemp -d)

if [[ "$2" = "--keep" ]]; then
    KEEP="true"
else
    KEEP="false"
fi

if [[ "$KEEP" = "false" ]]; then
    # setup auto cleanup
    trap "rm -rf $TEMP_DIR" EXIT
fi

DST_DIR_OS=""
DST_NAME=""

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DST_DIR_OS="linux-x64"
    DST_NAME="prettier"
elif [[ "$OSTYPE" == "cygwin" ]]; then
    DST_DIR_OS="win-x64"
    DST_NAME="prettier.exe"
elif [[ "$OSTYPE" == "msys" ]]; then
    DST_DIR_OS="win-x64"
    DST_NAME="prettier.exe"
elif [[ "$OSTYPE" == "win32" ]]; then
    DST_DIR_OS="win-x64"
    DST_NAME="prettier.exe"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

pushd "$TEMP_DIR"
echo "Using temporary directory $TEMP_DIR"
echo "Target directory is $DST_DIR"

cp "$SRC_DIR/package.json" "$TEMP_DIR/package.json"
cp "$SRC_DIR/prettier-deno.mjs" "$TEMP_DIR/prettier-deno.mjs"

yarn install
yarn add "prettier@$PRETTIER_VERSION"

mkdir -p "$DST_DIR/$DST_DIR_OS/"

APP_PATH="$DST_DIR/$DST_DIR_OS/$DST_NAME"

rm -f "$APP_PATH"

deno compile --unstable --allow-read --allow-env --allow-write --allow-sys --node-modules-dir=false --output="$APP_PATH" ./prettier-deno.mjs

# do a quick test if the binary is working
ACTUAL_VERSION=$("$APP_PATH" --version)

if [[ "$ACTUAL_VERSION" != "$PRETTIER_VERSION" ]]; then
    echo "Expected version $PRETTIER_VERSION, but got $ACTUAL_VERSION"
    exit 1
fi

popd
