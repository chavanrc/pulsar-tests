set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)
include(Versions)
find_package(spdlog REQUIRED QUIET)

if (spdlog_FOUND)
    message("-- Found spdlog library.")
    add_library(spdlog_external INTERFACE)
else ()
    message(STATUS "spdlog TAG: ${SPDLOG_TAG} could not be located.")
    include(ExternalProject)
    include(GNUInstallDirs)
    set(EXTERNAL_INSTALL_LOCATION ${STAGED_INSTALL_PREFIX}/spdlog)
    ExternalProject_Add(spdlog_external
            PREFIX
                ${EXTERNAL_INSTALL_LOCATION}
            GIT_REPOSITORY
                ${SPDLOG_URL}
            GIT_TAG
                ${SPDLOG_TAG}
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
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_LOCATION}
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
            CMAKE_CACHE_ARGS
                -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS})
    set(SPDLOG_ROOT ${EXTERNAL_INSTALL_LOCATION}
            CACHE PATH "Path to internally built spdlog installation root"
            FORCE)
    set(SPDLOG_INCLUDE_DIR ${SPDLOG_ROOT}/${CMAKE_INSTALL_INCLUDEDIR}
            CACHE PATH "Path to internally built spdlog include directories"
            FORCE)
    set(SPDLOG_LIB_PATH ${SPDLOG_ROOT}/${CMAKE_INSTALL_LIBDIR}
            CACHE PATH "Path to internally built spdlog library directories"
            FORCE)
    set(SPDLOG_CONFIG_DIR ${SPDLOG_LIB_PATH}/cmake/spdlog
            CACHE PATH "Path to internally built spdlog library config directories"
            FORCE)
    # Unset internal variables
    unset(EXTERNAL_INSTALL_LOCATION)
endif ()