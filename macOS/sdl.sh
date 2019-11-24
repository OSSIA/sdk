#!/bin/bash

source ./common.sh

wget -nv https://www.libsdl.org/release/SDL2-2.0.10.tar.gz
gtar xaf SDL2-2.0.10.tar.gz

mkdir sdl-build
cd sdl-build

xcrun cmake -DSDL_STATIC=1 \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_OSX_DEPLOYMENT_TARGET=$MACOS_VERSION \
 -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX/SDL2 \
 ../SDL2-2.0.10

xcrun make -j$NPROC
xcrun make install

ln -s $INSTALL_PREFIX/SDL2/SDL2.framework/Resources $INSTALL_PREFIX/SDL2/cmake
