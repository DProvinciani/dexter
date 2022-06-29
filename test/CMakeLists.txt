# General checks and configuration
project(dexter_test VERSION 1.0)

# Collecting sources
file(GLOB_RECURSE ${PROJECT_NAME}_SOURCES "*.cpp")

cmake_print_variables(${PROJECT_NAME}_SOURCES)

# Organizing files in the VS project
get_target_property(DEX_SOURCE_DIR dexter SOURCE_DIR)
source_group(TREE ${DEX_SOURCE_DIR} FILES
             ${dexter_INCLUDES}
             ${dexter_SOURCES_STRING}
             ${${PROJECT_NAME}_SOURCES}
             "main.cpp")

# Executables
add_executable(${PROJECT_NAME} 
               "main.cpp"
               ${${PROJECT_NAME}_SOURCES}
               ${dexter_INCLUDES}
               ${dexter_SOURCES_STRING})

target_include_directories(${PROJECT_NAME} PRIVATE
                           "../include/string")

# External deps
target_link_libraries(${PROJECT_NAME} PRIVATE
                      CONAN_PKG::plog
                      CONAN_PKG::gtest)

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

add_test(${PROJECT_NAME} ${CMAKE_BINARY_DIR}/bin/${PROJECT_NAME})
