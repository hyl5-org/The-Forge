# Handle library creation here.

set(ENGINE_RUNTIME_SOURCE_DIR ${ENGINE_SOURCE_DIR}/Runtime)
set(ENGINE_THIRD_PARTY_SOURCE_DIR ${ENGINE_SOURCE_DIR}/ThirdParty)

set(RUNTIME_FILES
        ${RENDERER_SOURCE_FILES}
        ${RENDERER_INCLUDE_FILES}
        ${RENDERER_FILES}
        ${OS_CAMERA_FILES}
        ${OS_CORE_FILES}
        ${OS_FILESYSTEM_FILES}
        ${OS_FONT_FILES}
        ${OS_FONT_SHADER_FILES}
        ${OS_INPUT_FILES}
        ${OS_INTERFACES_FILES}
        ${OS_LOGGING_FILES}
        ${OS_MATH_FILES}
        ${OS_MEMORYTRACKING_FILES}
        ${OS_MIDDLEWARE_FILES}
        ${OS_MIDDLEWARE_PANINI_SHADER_FILES}
        ${OS_PROFILER_FILES}
        ${OS_SCRIPTING_FILES}
        ${OS_UI_FILES}
        ${OS_UI_SHADER_FILES}
        ${OS_MIDDLEWARE_ANIMATION_FILES}
        ${OS_MIDDLEWARE_PARALLEL_PRIMS_FILES}
        ${OS_WINDOWSYSTEM_FILES}
        ${OS_PLATFORM_SPECIFIC_FILES}
)

if(${DYNAMIC_LIB} MATCHES OFF)
    add_library(BoundRuntime STATIC
        ${FORGE_FILES}
    )

else()
    add_library(BoundRuntime SHARED
        ${FORGE_FILES}
    )
endif()

target_include_directories(BoundRuntime PUBLIC
    ../BoundRuntime/Common_3/
    ${RENDER_INCLUDES}
)

set_target_properties(my_target PROPERTIES UNITY_BUILD ON)

target_link_libraries(BoundRuntime PUBLIC ${RENDER_LIBRARIES} ${THIRD_PARTY_DEPS})

target_link_directories(BoundRuntime PUBLIC ${RENDER_LIBRARY_PATHS})

target_compile_definitions(BoundRuntime PUBLIC ${RENDER_DEFINES})

# unity build
set_target_properties(BoundRuntime PROPERTIES UNITY_BUILD ON)

if (${APPLE_PLATFORM} MATCHES ON)
    set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++17 -stdlib=libc++ -x objective-c++")
    target_compile_options(BoundRuntime PRIVATE "-fobjc-arc")
endif()


