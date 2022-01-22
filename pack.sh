#!/usr/bin/env bash

set -e

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

yarn install

mkdir -p "$DST_DIR/win-x64/"
yarn pkg -t node14-win ./node_modules/prettier/bin-prettier.js -o "$DST_DIR/win-x64/prettier.exe"

mkdir -p "$DST_DIR/linux-x64/"
yarn pkg -t node14-linux ./node_modules/prettier/bin-prettier.js -o "$DST_DIR/linux-x64/prettier"

PRETTIER_VERSION=$(yarn list --pattern prettier --depth=0 --json --non-interactive --no-progress | \
    jq -r '.data.trees[].name' | grep "^prettier@" | sed -E 's/prettier@(.+)/\1/')

echo -n $PRETTIER_VERSION > "$DST_DIR/version"

popd
