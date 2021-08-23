set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)
include(Versions)
find_package(Boost ${Boost_MINIMUM_REQUIRED} QUIET COMPONENTS "${BOOST_COMPONENTS_REQUIRED}")

list(APPEND BOOST_COMPONENTS_REQUIRED coroutine context filesystem program_options regex system thread unit_test_framework)
if (Boost_FOUND)
    message(STATUS "Found Boost version ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION}")
    add_library(boost_external INTERFACE)
else ()
    message(STATUS "Boost ${Boost_MINIMUM_REQUIRED} could not be located.")

    if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        if (APPLE)
            set(_toolset "darwin")
        else ()
            set(_toolset "gcc")
        endif ()
    elseif (CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        set(_toolset "clang")
    elseif (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
        if (APPLE)
            set(_toolset "intel-darwin")
        else ()
            set(_toolset "intel-linux")
        endif ()
    endif ()

    if (NOT "${BOOST_COMPONENTS_REQUIRED}" STREQUAL "")
        string(REPLACE "unit_test_framework" "test" _b2_needed_components "${BOOST_COMPONENTS_REQUIRED}")
        set(_build_byproducts)
        set(_b2_select_libraries)
        foreach (_lib IN LISTS _b2_needed_components)
            list(APPEND _build_byproducts ${STAGED_INSTALL_PREFIX}/boost/lib/libboost_${_lib}${CMAKE_SHARED_LIBRARY_SUFFIX})
            list(APPEND _b2_select_libraries --with-${_lib})
        endforeach ()
        string(REPLACE ";" "," _b2_needed_components "${_b2_needed_components}")
        set(_bootstrap_select_libraries "--with-libraries=${_b2_needed_components}")
        string(REPLACE ";" ", " printout "${BOOST_COMPONENTS_REQUIRED}")
        message(STATUS "  Libraries to be built: ${printout}")
    endif ()

    include(ExternalProject)
    ExternalProject_Add(boost_external
            URL ${BOOST_URL}
            URL_HASH ${BOOST_HASH}
            DOWNLOAD_NO_PROGRESS 1
            UPDATE_COMMAND ${CMAKE_NOOP}
            CONFIGURE_COMMAND <SOURCE_DIR>/bootstrap.sh --with-toolset=${_toolset} --prefix=${STAGED_INSTALL_PREFIX}/boost ${_bootstrap_select_libraries} --with-python=python3
            BUILD_COMMAND <SOURCE_DIR>/b2 -q link=static threading=multi variant=release toolset=${_toolset} ${_b2_select_libraries}
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND <SOURCE_DIR>/b2 -q install link=static threading=multi variant=release toolset=${_toolset} ${_b2_select_libraries}
            LOG_BUILD 1
            LOG_INSTALL 1
            LOG_DOWNLOAD 1
            BUILD_BYPRODUCTS "${_build_byproducts}")

    set(BOOST_ROOT ${STAGED_INSTALL_PREFIX}/boost
            CACHE PATH "Path to internally built Boost installation root"
            FORCE)
    set(BOOST_INCLUDE_DIR ${BOOST_ROOT}/include
            CACHE PATH "Path to internally built Boost include directories"
            FORCE)
    set(BOOST_LIB_PATH ${BOOST_ROOT}/lib
            CACHE PATH "Path to internally built Boost library directories"
            FORCE)
    set(BOOST_CONFIG_DIR ${BOOST_LIB_PATH}/cmake/Boost-${BOOST_VERSION}
            CACHE PATH "Path to internally built boost library config directories"
            FORCE)
    # Unset internal variables
    unset(_toolset)
    unset(_b2_needed_components)
    unset(_build_byproducts)
    unset(_b2_select_libraries)
    unset(_boostrap_select_libraries)
endif ()
