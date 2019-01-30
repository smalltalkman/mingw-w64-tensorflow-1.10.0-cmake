#!/bin/bash
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PATCH_FILE=$BASE_PATH/$1.patch
TARGET_DIR=$2

echo ================================================================================

echo PATCH_FILE: $PATCH_FILE
echo TARGET_DIR: $TARGET_DIR

if [ ! -d "$TARGET_DIR.orig" ]; then
  echo "Backing '$TARGET_DIR' to '$TARGET_DIR.orig' ..."
  cp -rp "$TARGET_DIR" "$TARGET_DIR.orig"
fi

patch -N -b -p1 -i "$PATCH_FILE" -d "$TARGET_DIR"

echo ================================================================================
