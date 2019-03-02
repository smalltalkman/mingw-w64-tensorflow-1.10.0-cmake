#!/bin/bash
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cmake_build_dir=$1
cmake_build_dir=${cmake_build_dir:-cmake_build}

TF_VERSION=1.10.0
PATCHES_PATH=$BASE_PATH/src/tensorflow-$TF_VERSION/tensorflow/contrib/cmake/patches
CMAKE_BUILD=$BASE_PATH/src/$cmake_build_dir

function make_patch() {
  local params=("$@")
  local target=$1
  local files=${params[@]:1}
  
  local patch_file=$PATCHES_PATH/$target.patch
  local   src_path=$CMAKE_BUILD/$target/src
  
  echo "Making $patch_file ..."
  cat /dev/null > $patch_file
  cd $src_path
  for file in ${files[@]}; do
    echo "   $file ..."
    # diff -urN $target.orig/$file $target/$file > $PATCHES_PATH/$target-${file////-}.patch >> $patch_file;
    diff -urN $target.orig/$file $target/$file >> $patch_file;
  done
  
  echo "<- Coping to $BASE_PATH/$target.patch"
  cp -up $patch_file $BASE_PATH/$target.patch
}

make_patch grpc 'include/grpc/impl/codegen/port_platform.h'
make_patch nsync 'platform/win32/platform_c++11_os.h'
make_patch png 'CMakeLists.txt'
make_patch farmhash 'src\farmhash.h' 'src\farmhash.cc'
make_patch gemmlowp 'internal\platform.h'

cd $BASE_PATH/src
diff -ur tensorflow-$TF_VERSION.orig/tensorflow/contrib/cmake tensorflow-$TF_VERSION/tensorflow/contrib/cmake -x '*.patch' -x '*.orig' | grep -vi '^Only in' > $BASE_PATH/0001-fix-tensorflow-contrib-cmake.patch
diff -ur tensorflow-$TF_VERSION.orig/tensorflow/core          tensorflow-$TF_VERSION/tensorflow/core                       -x '*.orig' | grep -vi '^Only in' > $BASE_PATH/0002-fix-tensorflow-core.patch
diff -ur tensorflow-$TF_VERSION.orig/tensorflow/python        tensorflow-$TF_VERSION/tensorflow/python                     -x '*.orig' | grep -vi '^Only in' > $BASE_PATH/0004-fix-tensorflow-python.patch

function make_patch_for_file() {
  local base_dir=$1
  local orig_dir=$2
  local work_dir=$3
  local target_dir=$4
  local index=$5
  local file=$6
  
  cd $base_dir
  diff -urN $orig_dir/$file $work_dir/$file > $target_dir/$index-fix-${file////-}.patch
}

function make_patch_for_file_0() {
  make_patch_for_file $BASE_PATH/src tensorflow-$TF_VERSION.orig tensorflow-$TF_VERSION $BASE_PATH $1 $2
}

make_patch_for_file_0 0003 tensorflow/__init__.py
