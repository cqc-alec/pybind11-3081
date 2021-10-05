#include <pybind11/pybind11.h>
#include "A.hpp"

PYBIND11_MODULE(A, m) {
  pybind11::class_<A>(m, "A", "An A");
}

