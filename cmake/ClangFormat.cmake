find_program(CLANG_FORMAT
        NAMES "clang-format"
        DOC "Path to clang-format executable")

if (NOT CLANG_FORMAT)
    message(STATUS "clang-format not found.")
else ()
    message(STATUS "clang-format found: ${CLANG_FORMAT}")
    set(DO_CLANG_FORMAT "${CLANG_FORMAT}" "-i -style=file")
endif ()

if (CLANG_FORMAT)
    # get all project files
    file(GLOB_RECURSE ALL_SOURCE_FILES
            RELATIVE ${CMAKE_CURRENT_BINARY_DIR}
            ${CMAKE_SOURCE_DIR}/ds/*.cpp ${CMAKE_SOURCE_DIR}/ds/*.hpp ${CMAKE_SOURCE_DIR}/ds/*.inl
            ${CMAKE_SOURCE_DIR}/entity/*.cpp ${CMAKE_SOURCE_DIR}/entity/*.hpp ${CMAKE_SOURCE_DIR}/entity/*.inl
            ${CMAKE_SOURCE_DIR}/locks/*.cpp ${CMAKE_SOURCE_DIR}/locks/*.hpp ${CMAKE_SOURCE_DIR}/locks/*.inl
            ${CMAKE_SOURCE_DIR}/logger/*.cpp ${CMAKE_SOURCE_DIR}/logger/*.hpp ${CMAKE_SOURCE_DIR}/logger/*.inl
            ${CMAKE_SOURCE_DIR}/memrgn/*.cpp ${CMAKE_SOURCE_DIR}/memrgn/*.hpp ${CMAKE_SOURCE_DIR}/memrgn/*.inl
            ${CMAKE_SOURCE_DIR}/net/*.cpp ${CMAKE_SOURCE_DIR}/net/*.hpp ${CMAKE_SOURCE_DIR}/net/*.inl
            ${CMAKE_SOURCE_DIR}/utils/*.cpp ${CMAKE_SOURCE_DIR}/utils/*.hpp ${CMAKE_SOURCE_DIR}/utils/*.inl
            ${CMAKE_SOURCE_DIR}/tests/*.cpp ${CMAKE_SOURCE_DIR}/tests/*.hpp ${CMAKE_SOURCE_DIR}/tests/*.inl
            ${CMAKE_SOURCE_DIR}/utils/ucc_split/src/*.cpp ${CMAKE_SOURCE_DIR}/utils/ucc_split/include/*.hpp ${CMAKE_SOURCE_DIR}/utils/ucc_split/include/*.inl)

    add_custom_target(
            clang-format
            COMMAND ${CLANG_FORMAT} -style=file -i ${ALL_SOURCE_FILES})

    add_custom_target(
            clang-format-diff
            COMMAND ${CLANG_FORMAT} -style=file -i ${ALL_SOURCE_FILES}
            COMMAND git diff ${ALL_SOURCE_FILES}
            COMMENT "Formatting with clang-format (using ${CLANG_FORMAT}) and showing differences with latest commit"
    )
endif ()