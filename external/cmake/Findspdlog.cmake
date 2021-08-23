find_path(spdlog_INCLUDE_DIR
        NAMES spdlog/spdlog.h
        PATHS ${SPDLOG_INCLUDE_DIR}
        NO_CMAKE_SYSTEM_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        DOC "The directory where spdlog includes reside")

if(CMAKE_BUILD_TYPE MATCHES Debug)
    set(SPDLOG_LIBRARIES spdlogd)
else()
    set(SPDLOG_LIBRARIES spdlog)
endif()

find_library(spdlog_LIBRARY
        NAMES ${SPDLOG_LIBRARIES}
        PATHS ${SPDLOG_LIB_PATH}
        NO_CMAKE_SYSTEM_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        DOC "The spdlog library")

if (spdlog_INCLUDE_DIR AND spdlog_LIBRARY)
    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(spdlog DEFAULT_MSG
            spdlog_INCLUDE_DIR spdlog_LIBRARY)
    if (spdlog_FOUND)
        add_library(spdlog::spdlog STATIC IMPORTED)
        set_target_properties(spdlog::spdlog PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${spdlog_INCLUDE_DIR}"
                IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                IMPORTED_LOCATION "${spdlog_LIBRARY}")
    endif ()
endif ()