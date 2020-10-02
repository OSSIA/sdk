#!/bin/bash

source ./common.sh
CMAKE=cmake


# LLVM is bootstrapped so that it is all built with the same libc++ version
(
export PATH=$INSTALL_PREFIX/llvm/x86_64-w64-mingw32/bin:$PATH
rm -rf llvm-build
mkdir -p llvm-build
cd llvm-build

$CMAKE -G"MSYS Makefiles" \
 -DCMAKE_C_FLAGS="-O3" \
 -DCMAKE_CXX_FLAGS="-O3" \
 -DCMAKE_BUILD_TYPE=Release \
 -DBUILD_SHARED_LIBS=0 \
 -DLLVM_INCLUDE_TOOLS=1 \
 -DLLVM_BUILD_TOOLS=1 \
 -DLLVM_INCLUDE_EXAMPLES=0 \
 -DLLVM_INCLUDE_BENCHMARKS=0 \
 -DLLVM_INCLUDE_TESTS=0 \
 -DCMAKE_CXX_STANDARD=17 \
 -DLLVM_TARGETS_TO_BUILD="X86" \
 -DLLVM_ENABLE_LIBCXX=OFF \
 -DLLVM_ENABLE_LLD=OFF \
 -DLLVM_ENABLE_EH=ON \
 -DLLVM_ENABLE_RTTI=ON \
 -DLLVM_ENABLE_WARNINGS=OFF \
 -DLLVM_ENABLE_ZLIB=OFF \
 -DLLVM_ENABLE_BINDINGS=OFF \
 -DLLVM_ENABLE_PROJECTS="clang" \
 -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX/llvm-libs \
 ../llvm/llvm

make -j$NPROC
make install/strip/fast
)

exit 0
# old stuff


(
rm -rf llvm-build
mkdir -p llvm-build
cd llvm-build
$CMAKE -G"MSYS Makefiles" \
 -DCMAKE_BUILD_TYPE=Release \
 -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
 -DLLVM_TARGETS_TO_BUILD="X86" \
 -DLLVM_INCLUDE_EXAMPLES=0 \
 -DLLVM_INCLUDE_TESTS=0 \
 -DLLVM_ENABLE_CXX1Z=1 \
 -DCLANG_DEFAULT_CXX_STDLIB:STRING=libc++ \
 -DCLANG_DEFAULT_RTLIB:STRING=libgcc \
 -DLIBCXX_ABI_UNSTABLE=ON \
 -DLIBCXX_USE_COMPILER_RT=OFF \
 -DLIBCXXABI_USE_COMPILER_RT=OFF \
 -DLIBUNWIND_USE_COMPILER_RT=OFF \
 -DCMAKE_INSTALL_PREFIX=$SDK_ROOT/llvm-bootstrap \
 ../llvm

make -j$NPROC
make install/strip
)
exit 0

# LLVM is bootstrapped so that it is all built with the same libc++ version
(
rm -rf llvm-build
mkdir -p llvm-build
cd llvm-build
export PATH=$SDK_ROOT/llvm-bootstrap/bin:$PATH
export LD_LIBRARY_PATH=$SDK_ROOT/llvm-bootstrap/lib:$LD_LIBRARY_PATH

$CMAKE -G"MinGW Makefiles" \
 -DCMAKE_C_COMPILER=$SDK_ROOT/llvm-bootstrap/bin/clang \
 -DCMAKE_CXX_COMPILER=$SDK_ROOT/llvm-bootstrap/bin/clang++ \
 -DCMAKE_C_FLAGS="-O3" \
 -DCMAKE_CXX_FLAGS="-O3" \
 -DCMAKE_BUILD_TYPE=Release \
 -DBUILD_SHARED_LIBS=0 \
 -DLLVM_INCLUDE_TOOLS=1 \
 -DLLVM_BUILD_TOOLS=1 \
 -DLLVM_INCLUDE_EXAMPLES=0 \
 -DLLVM_INCLUDE_TESTS=0 \
 -DLLVM_ENABLE_CXX1Z=1 \
 -DLLVM_TARGETS_TO_BUILD="X86" \
 -DLLVM_ENABLE_LIBCXX=ON \
 -DLLVM_ENABLE_LLD=ON \
 -DLLVM_ENABLE_EH=ON \
 -DLLVM_ENABLE_RTTI=ON \
 -DCLANG_DEFAULT_CXX_STDLIB:STRING=libc++ \
 -DCLANG_DEFAULT_RTLIB:STRING=libgcc \
 -DLIBCXX_ABI_UNSTABLE=ON \
 -DLIBCXX_USE_COMPILER_RT=OFF \
 -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
 -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
 -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
 -DLIBCXXABI_USE_COMPILER_RT=OFF \
 -DLIBUNWIND_USE_COMPILER_RT=OFF \
 -DCOMPILER_RT_USE_BUILTINS_LIBRARY=OFF \
 -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX/llvm \
 ../llvm

make -j$NPROC
make install/strip
)
