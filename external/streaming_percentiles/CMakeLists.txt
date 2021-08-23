set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)
include(Versions)
find_package(streaming_percentiles REQUIRED QUIET)

if (streaming_percentiles_FOUND)
    message("-- Found streaming_percentiles library.")
    add_library(streaming_percentiles_external INTERFACE)
else ()
    message(STATUS "streaming_percentiles TAG: ${STREAMING_PERCENTILES_TAG} could not be located.")
    include(ExternalProject)
    include(GNUInstallDirs)
    set(EXTERNAL_INSTALL_LOCATION ${STAGED_INSTALL_PREFIX}/streaming_percentiles)
    ExternalProject_Add(streaming_percentiles_external
            DEPENDS
                boost_external
            PREFIX
                ${EXTERNAL_INSTALL_LOCATION}
            GIT_REPOSITORY
                ${STREAMING_PERCENTILES_URL}
            GIT_TAG
                ${STREAMING_PERCENTILES_TAG}
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
            PATCH_COMMAND
                cd cpp && git apply ${CMAKE_CURRENT_LIST_DIR}/assert.patch || git apply ${CMAKE_CURRENT_LIST_DIR}/assert.patch -R --check
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_LOCATION}
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                -DCMAKE_PREFIX_PATH=${BOOST_CONFIG_DIR}
                -DCMAKE_LIBRARY_PATH=${BOOST_LIB_PATH}
            CMAKE_CACHE_ARGS
                -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
                -DCMAKE_INCLUDE_PATH:PATH=${BOOST_INCLUDE_DIR}
                -DCMAKE_LIBRARY_PATH:PATH=${BOOST_LIB_PATH})
    set(STREAMING_PERCENTILES_ROOT ${EXTERNAL_INSTALL_LOCATION}
            CACHE PATH "Path to internally built streaming_percentiles installation root"
            FORCE)
    set(STREAMING_PERCENTILES_INCLUDE_DIR ${STREAMING_PERCENTILES_ROOT}/${CMAKE_INSTALL_INCLUDEDIR}
            CACHE PATH "Path to internally built streaming_percentiles include directories"
            FORCE)
    # Unset internal variables
    unset(EXTERNAL_INSTALL_LOCATION)
endif ()