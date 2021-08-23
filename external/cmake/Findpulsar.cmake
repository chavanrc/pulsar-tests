find_path(pulsar_INCLUDE_DIR
        NAMES pulsar/Authentication.h
        PATHS ${PULSAR_INCLUDE_DIR}
        NO_CMAKE_SYSTEM_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        DOC "The directory where pulsar includes reside")


set(PULSAR_LIBRARIES pulsar)

find_library(pulsar_LIBRARY
        NAMES ${PULSAR_LIBRARIES}
        PATHS ${PULSAR_LIB_PATH}
        NO_CMAKE_SYSTEM_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        DOC "The pulsar library")

if (pulsar_INCLUDE_DIR AND pulsar_LIBRARY)
    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(pulsar DEFAULT_MSG
            pulsar_INCLUDE_DIR pulsar_LIBRARY)
    if (pulsar_FOUND)
        add_library(pulsar::pulsar STATIC IMPORTED)
        set_target_properties(pulsar::pulsar PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${pulsar_INCLUDE_DIR}"
                IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                IMPORTED_LOCATION "${pulsar_LIBRARY}")
    endif ()
endif ()