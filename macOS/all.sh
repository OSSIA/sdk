#!/bin/bash

# ./deps.sh
./llvm-deps.sh
./qt.sh
./fftw.sh
./ffmpeg.sh
./sndfile.sh
./portaudio.sh
./sdl.sh
./jack.sh
./llvm-libs.sh
./faust.sh



tar caf score-sdk-mac.tar.gz $INSTALL_PREFIX

