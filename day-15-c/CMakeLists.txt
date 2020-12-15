cmake_minimum_required(VERSION 3.19)
project(day_15_C C)

set(CMAKE_C_STANDARD 11)

add_compile_options(-Ofast -march=native)

add_executable(day_15_C main.c)