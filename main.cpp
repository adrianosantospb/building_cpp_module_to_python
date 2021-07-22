#include <iostream>

#include <calculadora.h>

#include <pybind11/pybind11.h>

namespace py = pybind11;

int add(int i, int j) {
    return i + j;
}

PYBIND11_MODULE(exemplocalc, m) {
    m.doc() = "pybind11 example plugin"; // optional module docstring
    m.def("soma", &add, "A function which adds two numbers", py::arg("a"), py::arg("b"));
};