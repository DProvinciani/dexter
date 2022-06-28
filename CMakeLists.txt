include(CMakePrintHelpers)

# General checks and configuration
cmake_minimum_required(VERSION 3.12)

project(dexter VERSION 1.0)

set(CMAKE_DEBUG_POSTFIX "" CACHE STRING "Making empty debug postfix" FORCE)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Collecting headers and sources
file(GLOB_RECURSE ${PROJECT_NAME}_INCLUDES "include/*.h")
file(GLOB_RECURSE ${PROJECT_NAME}_SOURCES_STRING "src/string/*.cpp")

cmake_print_variables(${PROJECT_NAME}_INCLUDES)
cmake_print_variables(${PROJECT_NAME}_SOURCES_STRING)

# Organizing files in the VS project
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES
             ${${PROJECT_NAME}_INCLUDES}
             ${${PROJECT_NAME}_SOURCES_STRING}
             "src/main.cpp")

# Executables
add_executable(dexter 
               "src/main.cpp"
               ${${PROJECT_NAME}_SOURCES_STRING}
               ${${PROJECT_NAME}_INCLUDES})

configure_file("include/Definitions.h.in" Definitions.h)
target_include_directories(${PROJECT_NAME} PUBLIC
                           "${PROJECT_BINARY_DIR}")
target_include_directories(${PROJECT_NAME} PRIVATE
                           "include/string")

# External deps
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

target_link_libraries(${PROJECT_NAME} PRIVATE
                      CONAN_PKG::plog)

# Build options
target_compile_definitions(${PROJECT_NAME}
    PRIVATE
        _CRT_SECURE_NO_WARNINGS
        _UNICODE
        UNICODE
        NOMINMAX
)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)
target_compile_options(${PROJECT_NAME}
    PRIVATE
        $<$<CXX_COMPILER_ID:MSVC>:
            /MP /W3 /Zf>
)
set_target_properties(${PROJECT_NAME} PROPERTIES
    LINK_FLAGS
        "/ignore:4099" # warning LNK4099: PDB '.pdb' was not found ...
)
# Setup generation of debug symbols for Release builds
add_link_options($<$<CONFIG:Release>:/DEBUG$<SEMICOLON>/OPT:REF$<SEMICOLON>/OPT:ICF>)

# Adding testing project
add_subdirectory(test)