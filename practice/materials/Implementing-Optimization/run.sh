#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "run.sh build <clang dir>"
  echo "run.sh run <clang dir>"
  echo "run.sh test <clang dir>"
  echo "run.sh all <clang dir>"
  echo "ex)  ./run.sh all /<llvm-install-dir>/bin"
  exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  EXT=".dylib"
  ISYSROOT="-isysroot `xcrun --show-sdk-path`"
else
  EXT=".so"
  ISYSROOT=
fi

if [[ "$1" != "run" && "$1" != "test" ]]; then
  echo "----- build -----"
  LLVMCONFIG=$2/llvm-config
  CXXFLAGS=`$LLVMCONFIG --cxxflags`
  LDFLAGS=`$LLVMCONFIG --ldflags`
  LIBS=`$LLVMCONFIG --libs core irreader bitreader support --system-libs`
  SRCROOT=`$LLVMCONFIG --src-root`

  CXX=$2/clang++
  CXXFLAGS="$CXXFLAGS -std=c++17 -I\"${SRCROOT}/include\" -fPIC -g"
  set -e

  $CXX $ISYSROOT $CXXFLAGS $LDFLAGS $LIBS constfold.cpp -o ./libConstFold$EXT -shared
  $CXX $ISYSROOT $CXXFLAGS $LDFLAGS $LIBS fillundef.cpp -o ./libFillUndef$EXT -shared
  $CXX $ISYSROOT $CXXFLAGS $LDFLAGS $LIBS instmatch.cpp -o ./libInstMatch$EXT -shared
fi

if [[ "$1" != "build" && "$1" != "test" ]]; then
  set +e
  echo "----- run constfold with constfold.ll -----"
  $2/opt -load-pass-plugin=./libConstFold$EXT \
         -passes="const-fold" constfold.ll -S -o -

  echo "----- run fillundef with fillundef.ll -----"
  $2/opt -load-pass-plugin=./libFillUndef$EXT \
         -passes="fill-undef" fillundef.ll -S -o -

  echo "----- run instmatch with instmatch.ll -----"
  $2/opt -load-pass-plugin=./libInstMatch$EXT -disable-output \
         -passes="inst-match" instmatch.ll
fi

if [[ "$1" != "build" && "$1" != "run" ]]; then
  set +e
  echo "----- test constfold -----"
  for f in constfold constfold-bad ; do
    echo "== ${f}.ll =="
    $2/opt -load-pass-plugin=./libConstFold$EXT \
           -passes="const-fold" ${f}.ll -S -o constfold.out.ll
    $2/FileCheck ${f}.ll < constfold.out.ll
  done
fi
