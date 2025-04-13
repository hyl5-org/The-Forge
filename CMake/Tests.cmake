cmake_minimum_required(VERSION 3.16)

set(VB_PROJECT_DIR ${ENGINE_DIR}/Tests/Visibility_Buffer2)

# Project name
set(PROJECT_NAME VisbilityBuffer)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE VB_INCLUDE_FILES ${VB_PROJECT_DIR}/Sources/*.h)
file(GLOB_RECURSE VB_SOURCE_FILES ${VB_PROJECT_DIR}/Sources/*.cpp)
file(GLOB_RECURSE VB_SHADER_FILES ${VB_PROJECT_DIR}/Shaders/*)

source_group(TREE ${VB_PROJECT_DIR} FILES ${VB_INCLUDE_FILES} ${VB_SOURCE_FILES})
source_group(TREE ${VB_PROJECT_DIR} PREFIX "Shaders" FILES ${VB_SHADER_FILES})

# Add executable
add_executable(${PROJECT_NAME} ${VB_SOURCE_FILES})

target_include_directories(${PROJECT_NAME} PUBLIC
    ${RUNTIME_INCLUDE_DIR}
)

target_link_libraries(${PROJECT_NAME} PRIVATE ${ENGINE_RUNTIME})
