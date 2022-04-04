#!/bin/bash

# Specify LLVM installation directory
LLVM_DIR=/opt/llvm-swpp
# Specify Z3 installation directory (Z3 will be installed here!)
Z3_DIR=/opt/z3

# # Download Z3 source
git clone -b z3-4.8.15 https://github.com/Z3Prover/z3.git --depth=1
cd z3
cmake -GNinja -Bbuild \
    -DCMAKE_INSTALL_PREFIX=$Z3_DIR
cmake --build build
sudo cmake --install build

# Download Alive2 source
cd ../
git clone https://github.com/AliveToolkit/alive2.git
cd alive2

# Build Alive2
cmake -GNinja -Bbuild \
    -DBUILD_TV=ON \
    -DCMAKE_PREFIX_PATH="$LLVM_DIR;$Z3_DIR" \
    -DCMAKE_BUILD_TYPE=Release
cmake --build build
