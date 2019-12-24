#!/bin/bash

source ./common.sh

wget -nv http://www.portaudio.com/archives/pa_snapshot.tgz
gtar xaf pa_snapshot.tgz

gsed -i '378i TARGET_INCLUDE_DIRECTORIES(portaudio_static PUBLIC "$<INSTALL_INTERFACE:include>")' portaudio/CMakeLists.txt

cd portaudio/build

xcrun cmake .. \
 -DCMAKE_BUILD_TYPE=Release \
 -DPA_BUILD_SHARED=Off \
 -DCMAKE_OSX_SYSROOT=$MACOS_SYSROOT \
 -DCMAKE_OSX_DEPLOYMENT_TARGET=$MACOS_VERSION \
 -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX/portaudio

xcrun make -j$NPROC
xcrun make install
