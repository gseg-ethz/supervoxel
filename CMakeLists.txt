cmake_minimum_required(VERSION 3.24)
project(supervoxel VERSION 1.0 LANGUAGES C CXX)

# ─────────────── Global options ──────────────────────────────────────
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ─────────────── Dependencies ────────────────────────────────────────
find_package(PCL 1.8 REQUIRED)
find_package(Boost REQUIRED COMPONENTS filesystem)
find_package(OpenMP)                       # optional
find_package(Python3 3.10 REQUIRED          # Python + NumPy headers
             COMPONENTS Development NumPy)
find_package(SWIG 4.2 REQUIRED)
include(${SWIG_USE_FILE})

# Show what header directory was picked
message(STATUS "NumPy headers: ${Python3_NumPy_INCLUDE_DIRS}")
message(STATUS "NumPy version: ${Python3_NumPy_VERSION}")

# ─────────────── Core C++ library (no Python) ────────────────────────
add_library(supervoxel_cpp STATIC
    cpp/src/supervoxel.cpp)

target_include_directories(supervoxel_cpp
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp/include>
        $<INSTALL_INTERFACE:include>
        ${PCL_INCLUDE_DIRS}
        ${Boost_INCLUDE_DIRS}
        ${Python3_NumPy_INCLUDE_DIRS})

target_compile_definitions(supervoxel_cpp PRIVATE
    NPY_NO_DEPRECATED_API=NPY_2_0_API_VERSION)    # NumPy 2.0 C‑API

target_compile_options(supervoxel_cpp PRIVATE
    -g -Wall -pedantic -Wextra -Wno-unused-parameter)

target_link_libraries(supervoxel_cpp
    PUBLIC
        ${PCL_LIBRARIES}
        ${Boost_LIBRARIES}
        ${OpenMP_CXX_LIBRARIES})

# ─────────────── SWIG / Python module ────────────────────────────────
# Generate wrapper into the Python package directory
set(CMAKE_SWIG_OUTDIR "${CMAKE_CURRENT_SOURCE_DIR}/src/supervoxel")

# mark interface as C++ → SWIG emits .cxx and UseSWIG compiles with g++
set_source_files_properties(
    src/supervoxel/supervoxel.i
    PROPERTIES CPLUSPLUS ON)

include_directories(                       # visible to SWIG pre‑processor
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/include
    ${Python3_NumPy_INCLUDE_DIRS}
    ${PCL_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

swig_add_library(supervoxel                # produces _supervoxel.*.so / .pyd
    TYPE     MODULE
    LANGUAGE python
    SOURCES  src/supervoxel/supervoxel.i)

target_include_directories(supervoxel PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/include
    ${Python3_NumPy_INCLUDE_DIRS}
    ${PCL_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

target_compile_definitions(supervoxel PRIVATE
    NPY_NO_DEPRECATED_API=NPY_2_0_API_VERSION)

target_link_libraries(supervoxel PRIVATE
    supervoxel_cpp
    Python3::Python)                       # links libpython + brings NumPy runtime

# ─────────────── Install rules (picked up by scikit‑build‑core) ──────
install(TARGETS supervoxel DESTINATION supervoxel)          # inside wheel
install(TARGETS supervoxel_cpp ARCHIVE DESTINATION lib)      # optional C++ lib
install(DIRECTORY cpp/include/ DESTINATION include)          # headers (sdist/wheel)

