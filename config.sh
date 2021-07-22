#!/bin/sh

DIR="./build"

echo "Configurando o diretorio ${DIR} e executando o cmake."

if [ -d "$DIR" ]; then
    cmake -S . -B build
else
    mkdir build && cd build
    cmake ..
fi

