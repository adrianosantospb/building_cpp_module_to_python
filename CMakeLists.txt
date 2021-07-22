# Define a versao minima do cmake
cmake_minimum_required(VERSION 3.10.2)

# Cria uma variavel com o nome do projeto
project(exemplocalc)
set(default_build_type "Release")

# Para buscar possiveis dependencias do projeto.
find_package(PythonLibs REQUIRED)
include_directories(${PYTHON_INCLUDE_DIRS})

# Adiciona arquivos ao projeto (classes, funcoes, etc...)
# add_library(${PROJECT_NAME} main.cpp)
# add_executable: para executaveis...
# add_library: pâra bibliotecas

# Cria um subprojeto dentro do projeto principal como uma biblioteca (executa o CMakeLists.txt interno)
add_subdirectory(calc)


# Download dos submodulos utilizados no projeto de forma automatica
message(STATUS "Loading submodules")
find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    message(STATUS "Submodule update")
    execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            RESULT_VARIABLE GIT_SUBMOD_RESULT)
    if(NOT GIT_SUBMOD_RESULT EQUAL "0")
        message(FATAL_ERROR "git submodule update --init failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
    endif()
elseif(NOT EXISTS "${PROJECT_SOURCE_DIR}/.git")
    message(FATAL_ERROR "While trying to load dependent submodules, .git directory not found")
elseif(NOT GIT_FOUND)
    message(FATAL_ERROR "While trying to load dependent submodules,
    git package not found. Install with 'apt install git'")
endif()



# Modulo do github
add_subdirectory(external/pybind11 pybind11)
pybind11_add_module(${PROJECT_NAME} MODULE main.cpp)

# Cria um link do projeto com o diretorio da biblioteca (adiciona a visibilidade (PRIVATE ou PUBLIC))
# Alem disso, criando esse link eh possivel referenciar as bibliotecas de forma padao <biblioteca.h>, sem necessidade de passar o caminho relativo.
target_include_directories(${PROJECT_NAME} 
    PUBLIC calc/ 
    PUBLIC external/pybind11/include
) # aparentemente, sempre que tiver uma pasta include, significa dizer que as bibliotecas serao geradas nela

# Cria um link entre a biblioteca criada e o projeto principal
#target_link_libraries(${PROJECT_NAME} calc)
#target_link_libraries(${PROJECT_NAME} PUBLIC calculadora)