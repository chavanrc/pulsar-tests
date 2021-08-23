cmake_minimum_required(VERSION 3.17 FATAL_ERROR)

project(external LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif ()

message(STATUS "Build type set to ${CMAKE_BUILD_TYPE}")

set(BUILD_WITH_MARCH_NATIVE OFF CACHE BOOL "Enable architecture-aware optimization (-march=native)")
if(BUILD_WITH_MARCH_NATIVE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mtune=native -march=native")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mtune=native -march=native")
    message(STATUS "Architecture-aware optimization (-march=native): ENABLED")
else()
    message(STATUS "Architecture-aware optimization (-march=native): DISABLED")
endif()

set(CMAKE_NOOP ${CMAKE_COMMAND} -E echo)
set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "Verbose makefile output")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(Versions)
include(GNUInstallDirs)
set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR}/subprojects)

set(STAGED_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/stage)
message(STATUS "${PROJECT_NAME} staged install: ${STAGED_INSTALL_PREFIX}")

add_subdirectory(benchmark)

set(Boost_MINIMUM_REQUIRED ${BOOST_VERSION})
add_subdirectory(boost)

add_subdirectory(catch)

add_subdirectory(spdlog)

add_subdirectory(streaming_percentiles)

include(ExternalProject)
ExternalProject_Add(dummy
        DEPENDS
            catch_external
            spdlog_external
            streaming_percentiles_external
            boost_external
        SOURCE_DIR
            ${CMAKE_CURRENT_LIST_DIR}/src
        CMAKE_ARGS
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
            -DCMAKE_CXX_EXTENSIONS=${CMAKE_CXX_EXTENSIONS}
            -DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}
        CMAKE_CACHE_ARGS
            -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
            -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH};
                                     ${BOOST_CONFIG_DIR};
            -DCMAKE_INCLUDE_PATH:PATH=${BOOST_INCLUDE_DIR};
            -DCMAKE_LIBRARY_PATH:PATH=${BOOST_LIB_PATH};
        BUILD_ALWAYS
            0
        INSTALL_COMMAND
            ${CMAKE_NOOP})
