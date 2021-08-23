set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)
include(Versions)
find_package(pulsar REQUIRED QUIET)

if (pulsar_FOUND)
    message("-- Found pulsar library.")
    add_library(pulsar_external INTERFACE)
else ()
    message(STATUS "pulsar TAG: ${PULSAR_TAG} could not be located.")
    include(ExternalProject)
    include(GNUInstallDirs)
    set(EXTERNAL_INSTALL_LOCATION ${STAGED_INSTALL_PREFIX}/pulsar)
    ExternalProject_Add(pulsar_external
            PREFIX
                ${EXTERNAL_INSTALL_LOCATION}
            GIT_REPOSITORY
                ${PULSAR_URL}
            GIT_TAG
                ${PULSAR_TAG}
            GIT_SUBMODULES_RECURSE
                1
            GIT_SHALLOW
                1
            GIT_PROGRESS
                1
            LOG_CONFIGURE
                1
            LOG_BUILD
                1
            LOG_INSTALL
                1
            LOG_DOWNLOAD
                1
            UPDATE_COMMAND
                ${CMAKE_NOOP}
            SOURCE_SUBDIR
                ./pulsar-client-cpp
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_LOCATION}
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                -DBUILD_TESTS:BOOL=OFF
                -DBUILD_PYTHON_WRAPPER:BOOL=OFF
                -DLINK_STATIC:BOOL=OFF
            CMAKE_CACHE_ARGS
                -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS})
    set(PULSAR_ROOT ${EXTERNAL_INSTALL_LOCATION}
            CACHE PATH "Path to internally built pulsar installation root"
            FORCE)
    set(PULSAR_INCLUDE_DIR ${PULSAR_ROOT}/${CMAKE_INSTALL_INCLUDEDIR}
            CACHE PATH "Path to internally built pulsar include directories"
            FORCE)
    set(PULSAR_LIB_PATH ${PULSAR_ROOT}/${CMAKE_INSTALL_LIBDIR}
            CACHE PATH "Path to internally built pulsar library directories"
            FORCE)
    # Unset internal variables
    unset(EXTERNAL_INSTALL_LOCATION)
endif ()