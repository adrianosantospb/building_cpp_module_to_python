# Define a versao minima do cmake
cmake_minimum_required(VERSION 3.10.2)

# Cria uma variavel com o nome do projeto
project(CMAKE_LEARNING)

# Adiciona arquivos ao projeto (classes, funcoes, etc...)
add_executable(${PROJECT_NAME} main.cpp)

# Cria um subprojeto dentro do projeto principal como uma biblioteca (executa o CMakeLists.txt interno)
add_subdirectory(calc)

# Modulo do github
add_subdirectory(external/pybind11)

# Cria um link do projeto com o diretorio da biblioteca (adiciona a visibilidade (PRIVATE ou PUBLIC))
# Alem disso, criando esse link eh possivel referenciar as bibliotecas de forma padao <biblioteca.h>, sem necessidade de passar o caminho relativo.
target_include_directories(${PROJECT_NAME} PRIVATE calc/)

# Cria um link entre a biblioteca criada e o projeto principal
target_link_libraries(${PROJECT_NAME} calc)