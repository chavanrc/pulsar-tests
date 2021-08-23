cmake_minimum_required(VERSION 3.17 FATAL_ERROR)

project(tests LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

list(APPEND CMAKE_MODULE_PATH ../cmake ../external/cmake)

find_package(Boost CONFIG REQUIRED ALL)

find_package(Catch2 CONFIG REQUIRED QUIET)

find_package(spdlog CONFIG REQUIRED QUIET)

find_package(Threads REQUIRED)

find_library(LIB_RT rt)

set(SOURCE_FILES
        main.cpp
        pulser_tests.cpp)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})

target_link_libraries(${PROJECT_NAME} ${Boost_LIBRARIES} Threads::Threads rt Catch2::Catch2 spdlog::spdlog pulsar)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

#target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra)
