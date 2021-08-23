cmake_minimum_required(VERSION 3.17 FATAL_ERROR)

project(dummy LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)

find_package(Boost CONFIG REQUIRED ALL)

include_directories(${CMAKE_INCLUDE_PATH})

add_executable(${PROJECT_NAME} dummy.cpp)

target_link_libraries(${PROJECT_NAME} PUBLIC ${Boost_LIBRARIES})
