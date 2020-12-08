cmake_minimum_required(VERSION 3.19)
project(day_08_cpp_compile_time)

set(CMAKE_CXX_STANDARD 17)

add_compile_options(-fconstexpr-steps=10000000)

add_executable(day_08_cpp_compile_time main.cpp)