cmake_minimum_required(VERSION 3.19)
project(day_14_cpp)

set(CMAKE_CXX_STANDARD 17)

add_executable(day_14_cpp main.cpp)

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/input.txt
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR})