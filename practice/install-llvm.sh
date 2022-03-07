#!/bin/bash

# Install necessary dependencies
# Package names may slightly differ in macOS (brew)
sudo apt update
sudo apt -y install git curl g++ cmake ninja-build python3-distutils zlib1g-dev \
libncurses-dev

# Download LLVM source
curl -OL https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/llvm-project-13.0.1.src.tar.xz
tar -xf llvm-project-13.0.1.src.tar.xz
cd llvm-project-13.0.1.src

# Create LLVM installation directory
LLVM_DIR=/opt/llvm # Edit this directory
sudo mkdir $LLVM_DIR

# Build LLVM
cmake -G Ninja -S llvm -B build \
    -DLLVM_ENABLE_PROJECTS="clang;lldb" \
    # M1 mac users should use AArch64 instead of X86
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_INSTALL_PREFIX=$LLVM_DIR
sudo cmake --build build --target install
