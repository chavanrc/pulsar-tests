find_path(streaming_percentiles_INCLUDE_DIR
        NAMES stmpct/gk.hpp
        PATHS ${STREAMING_PERCENTILES_INCLUDE_DIR}
        NO_CMAKE_SYSTEM_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        DOC "The directory where streaming-percentiles includes reside")

if (streaming_percentiles_INCLUDE_DIR)
    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(streaming_percentiles DEFAULT_MSG
            streaming_percentiles_INCLUDE_DIR)
endif ()