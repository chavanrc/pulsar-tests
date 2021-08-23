# Generate compile_commands.json to make it easier to work with clang based tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(FindOpenSSL)

find_package(Threads REQUIRED)

find_package(ZLIB REQUIRED)

find_library(LIBRT rt)

include(Ccache)

include(Ipo)

include(Doxygen)

include(StaticAnalyzers)

include(Sanitizers)

include(ClangFormat)

