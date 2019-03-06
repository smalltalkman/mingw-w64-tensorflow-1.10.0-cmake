mingw-w64-tensorflow
====================

## Usage:
 - Install [msys2](http://www.msys2.org/)
 - git clone https://github.com/smalltalkman/mingw-w64-tensorflow-1.10.0-cmake.git mingw-w64-tensorflow
 - cd mingw-w64-tensorflow
 - if ming64:
 > `MINGW_INSTALLS=mingw64 makepkg-mingw -sLf`  
 > `pacman -U mingw-w64-x86_64-python{2,3}-tensorflow-1.10.0-1-any.pkg.tar.xz`  
 - if ming32:
 > `MINGW_INSTALLS=mingw32 makepkg-mingw -sLf`  
 > `pacman -U mingw-w64-i686-python{2,3}-tensorflow-1.10.0-1-any.pkg.tar.xz`  

## TODO:
 - Use the dynamic link library provided by mingw32/mingw64 system, such as zlib, protobuf, grpc, etc.
 - Many **Segmentation Fault** errors under mingw64.
 - CUDA acceleration support
