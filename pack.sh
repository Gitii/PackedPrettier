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

# setup auto cleanup
trap "rm -rf $TEMP_DIR" EXIT

pushd "$TEMP_DIR"
echo "Using temporary directory $TEMP_DIR"
echo "Target directory is $DST_DIR"

cp "$SRC_DIR/package.json" "$TEMP_DIR/package.json"
cp "$SRC_DIR/pkg.config.json" "$TEMP_DIR/pkg.config.json"

yarn install
yarn add "prettier@$PRETTIER_VERSION" @prettier/plugin-xml prettier-plugin-sh

mkdir -p "$DST_DIR/win-x64/"
yarn pkg -t node14-win ./node_modules/prettier/bin-prettier.js -o "$DST_DIR/win-x64/prettier.exe" --config ./pkg.config.json

mkdir -p "$DST_DIR/linux-x64/"
yarn pkg -t node14-linux ./node_modules/prettier/bin-prettier.js -o "$DST_DIR/linux-x64/prettier" --config ./pkg.config.json

echo -n $PRETTIER_VERSION > "$DST_DIR/version"

popd
