# Handle library creation here.

set(ENGINE_RUNTIME_SOURCE_DIR ${ENGINE_SOURCE_DIR}/Runtime)
set(ENGINE_RUNTIME Runtime)

# Do some OS checks, and setup accordingly.
set(WINDOWS OFF)

set(DX12 ON)

# Make our APIs into options
option(EXAMPLES "The Forge examples" OFF)
option(DYNAMIC_LIB "Dynamic Library" OFF)

set(ASSIMP OFF)
set(OZZ OFF)

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    message("Windows detected. Generating Windows targets.")
    set(WINDOWS ON)
endif()

# Setup some sane API defaults.
set(API_SELECTED ON)

if(${DX12} MATCHES ON)
    #add_compile_definitions(DIRECT3D12) 
endif()

message("\n")

include(Platform)
include(Core)
include(RHI)
include(Resources)
include(Graphics)

source_group(TREE ${CORE_INTERFACE_DIR} PREFIX "Header Files" FILES ${CORE_INTERFACE_FILES})
source_group(TREE ${CORE_SOURCE_DIR} PREFIX "Source Files\\Core" FILES ${CORE_INCLUDE_FILES} ${CORE_SOURCE_FILES})

source_group(TREE ${PLATFORM_INTERFACE_DIR} PREFIX "Header Files" FILES ${PLATFORM_INTERFACE_FILES})
source_group(TREE ${PLATFORM_SOURCE_DIR} PREFIX "Source Files\\Platform" FILES ${PLATFORM_INCLUDE_FILES} ${PLATFORM_SOURCE_FILES})

source_group(TREE ${RHI_INTERFACE_DIR} PREFIX "Header Files" FILES ${RHI_INTERFACE_FILES})
source_group(TREE ${RHI_SOURCE_DIR} PREFIX "Source Files\\RHI" FILES ${RHI_INCLUDE_FILES} ${RHI_SOURCE_FILES})

source_group(TREE ${RESOURCES_INTERFACE_DIR} PREFIX "Header Files" FILES ${RESOURCES_INTERFACE_FILES})
source_group(TREE ${RESOURCES_SOURCE_DIR} PREFIX "Source Files\\Resources" FILES ${RESOURCES_INCLUDE_FILES} ${RESOURCES_SOURCE_FILES})

source_group(TREE ${GRAPHICS_INTERFACE_DIR} PREFIX "Header Files" FILES ${GRAPHICS_INTERFACE_FILES})
source_group(TREE ${GRAPHICS_SOURCE_DIR} PREFIX "Source Files\\Graphics" FILES ${GRAPHICS_INCLUDE_FILES} ${GRAPHICS_SOURCE_FILES})

set(RUNTIME_INTERFACE_FILES
    ${CORE_INTERFACE_FILES}
    ${PLATFORM_INTERFACE_FILES}
    ${RHI_INTERFACE_FILES}
    ${RESOURCES_INTERFACE_FILES}
    ${GRAPHICS_INTERFACE_FILES}
)

set(RUNTIME_SOURCE_FILES
    ${CORE_INCLUDE_FILES}
    ${CORE_SOURCE_FILES}
    ${PLATFORM_INCLUDE_FILES}
    ${PLATFORM_SOURCE_FILES}
    ${RHI_INCLUDE_FILES}
    ${RHI_SOURCE_FILES}
    ${RESOURCES_INCLUDE_FILES}
    ${RESOURCES_SOURCE_FILES}
    #${GRAPHICS_INCLUDE_FILES}
    #${GRAPHICS_SOURCE_FILES}
)

if(${DYNAMIC_LIB} MATCHES OFF)
    add_library(${ENGINE_RUNTIME} STATIC
        ${RUNTIME_SOURCE_FILES}
        ${RUNTIME_INTERFACE_FILES}
    )

else()
    add_library(${ENGINE_RUNTIME} SHARED
        ${RUNTIME_SOURCE_FILES}
        ${RUNTIME_INTERFACE_FILES}
    )
endif()

target_include_directories(${ENGINE_RUNTIME} PUBLIC
    ${ENGINE_SOURCE_DIR}
    ${ENGINE_RUNTIME_SOURCE_DIR}/Platform/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Core/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/RHI/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Resources/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Graphics/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Application/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Scripting/Public
)

# https://cmake.org/cmake/help/latest/command/target_precompile_headers.html
target_precompile_headers(${ENGINE_RUNTIME} INTERFACE
    #$<$<COMPILE_LANGUAGE:CXX>:${RUNTIME_INTERFACE_FILES}>
    ${RUNTIME_INTERFACE_FILES}>
)

target_link_libraries(${ENGINE_RUNTIME} PUBLIC ${RHI_LIBRARIES} ${THIRD_PARTY_DEPS})

target_link_directories(${ENGINE_RUNTIME} PUBLIC ${RHI_LIBRARY_PATHS})

target_compile_definitions(${ENGINE_RUNTIME} PUBLIC ${RHI_DEFINES})

# unity build
set_target_properties(${ENGINE_RUNTIME} PROPERTIES UNITY_BUILD ON)

set_property(TARGET ${ENGINE_RUNTIME} PROPERTY CXX_STANDARD 20)
