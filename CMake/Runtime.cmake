# Handle library creation here.

set(ENGINE_RUNTIME_SOURCE_DIR ${ENGINE_SOURCE_DIR}/Runtime)

include(Platform)
include(Core)
include(RHI)


source_group(TREE ${CORE_INTERFACE_DIR} PREFIX "Header Files" FILES ${CORE_INTERFACE_FILES})
source_group(TREE ${CORE_SOURCE_DIR} PREFIX "Source Files" FILES ${CORE_INCLUDE_FILES} ${CORE_SOURCE_FILES})

set(RUNTIME_INTERFACE_FILES

    # ${RHI_SOURCE_FILES}
    # ${RHI_INCLUDE_FILES}
    # ${RHI_FILES}
    ${CORE_INTERFACE_FILES}

    # ${PLATFORM_WINDOWS_SOURCE_FILES}

    # ${CORE_CAMERA_FILES}
    # ${CORE_CORE_FILES}
    # ${CORE_FILESYSTEM_FILES}
    # #${PLATFORM_INPUT_FILES}
    # #${OS_INTERFACES_FILES}
    # ${CORE_LOGGING_FILES}
    # ${CORE_MATH_FILES}
    # ${CORE_MEMORYTRACKING_FILES}
)

set(RUNTIME_SOURCE_FILES

    # ${RHI_SOURCE_FILES}
    # ${RHI_INCLUDE_FILES}
    # ${RHI_FILES}
    ${CORE_INTERFACE_FILES}
    ${CORE_INCLUDE_FILES}
    ${CORE_SOURCE_FILES}

    # ${PLATFORM_WINDOWS_SOURCE_FILES}

    # ${CORE_CAMERA_FILES}
    # ${CORE_CORE_FILES}
    # ${CORE_FILESYSTEM_FILES}
    # #${PLATFORM_INPUT_FILES}
    # #${OS_INTERFACES_FILES}
    # ${CORE_LOGGING_FILES}
    # ${CORE_MATH_FILES}
    # ${CORE_MEMORYTRACKING_FILES}
)

if(${DYNAMIC_LIB} MATCHES OFF)
    add_library(BoundRuntime STATIC
        ${RUNTIME_SOURCE_FILES}
        ${RUNTIME_INTERFACE_FILES}
    )

else()
    add_library(BoundRuntime SHARED
        ${RUNTIME_SOURCE_FILES}
        ${RUNTIME_INTERFACE_FILES}
    )
endif()

target_include_directories(BoundRuntime PUBLIC
    ${ENGINE_SOURCE_DIR}
    ${ENGINE_RUNTIME_SOURCE_DIR}/Platform/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Core/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/RHI/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Renderer/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Resource/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Application/Public
    ${ENGINE_RUNTIME_SOURCE_DIR}/Scripting/Public

    # ${RENDER_INCLUDES}
)

target_link_libraries(BoundRuntime PUBLIC ${RENDER_LIBRARIES} ${THIRD_PARTY_DEPS})

target_link_directories(BoundRuntime PUBLIC ${RENDER_LIBRARY_PATHS})

target_compile_definitions(BoundRuntime PUBLIC ${RENDER_DEFINES})

# unity build
set_target_properties(BoundRuntime PROPERTIES UNITY_BUILD ON)

if (${APPLE_PLATFORM} MATCHES ON)
    set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++17 -stdlib=libc++ -x objective-c++")
    target_compile_options(BoundRuntime PRIVATE "-fobjc-arc")
endif()


