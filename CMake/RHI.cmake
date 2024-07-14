# RHI

set(RHI_INCLUDE_DIR ${ENGINE_RUNTIME_SOURCE_DIR}/RHI/Public)
set(RHI_SOURCE_DIR ${ENGINE_RUNTIME_SOURCE_DIR}/RHI/Private)


file(GLOB RHI_SOURCE_FILES ${RHI_SOURCE_DIR}/*.cpp)

# set(RHI_SOURCE_FILES
# ${RHI_SOURCE_DIR}/*.cpp
# )
file(GLOB RHI_INCLUDE_FILES ${RHI_SOURCE_DIR}/Interfaces/*.h)
# set(RHI_INCLUDE_FILES
#     ${RHI_SOURCE_DIR}/Interfaces/*.h
# )

set(METAL_FILES
    ${RHI_SOURCE_DIR}/Metal/MetalAvailabilityMacros.h
    ${RHI_SOURCE_DIR}/Metal/MetalCapBuilder.h
    ${RHI_SOURCE_DIR}/Metal/MetalConfig.h
    ${RHI_SOURCE_DIR}/Metal/MetalMemoryAllocator.h
    ${RHI_SOURCE_DIR}/Metal/MetalMemoryAllocatorImpl.h
    ${RHI_SOURCE_DIR}/Metal/MetalRaytracing.mm
    ${RHI_SOURCE_DIR}/Metal/MetalRenderer.mm
    ${RHI_SOURCE_DIR}/Metal/MetalShaderReflection.mm
)

set(RENDER_QUEST_FILES
    ${RHI_SOURCE_DIR}/Quest/VrApiHooks.cpp
    ${RHI_SOURCE_DIR}/Quest/VrApiHooks.h
)

file(GLOB DX11_FILES ${RHI_SOURCE_DIR}/Direct3D11/*.cpp)
# set(DX11_FILES
#     ${RHI_SOURCE_DIR}/Direct3D11/*.cpp
# )
file(GLOB DX12_FILES ${RHI_SOURCE_DIR}/Direct3D12/*.cpp)
# set(DX12_FILES
#     ${RHI_SOURCE_DIR}/Direct3D12/*.cpp
# )
file(GLOB VULKAN_FILES ${RHI_SOURCE_DIR}/Vulkan/*.cpp)
# set(VULKAN_FILES
#     ${RHI_SOURCE_DIR}/Vulkan/*.cpp
# )

if(${METAL} MATCHES ON)
    find_library(APPLE_METAL Metal)
    find_library(APPLE_METALKIT MetalKit)
    find_library(APPLE_METALPS MetalPerformanceShaders)

    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        ${APPLE_METAL}
        ${APPLE_METALKIT}
        ${APPLE_METALPS}
    )

    set(RHI_FILES ${RHI_FILES} ${METAL_FILES})
endif()

if(${VULKAN} MATCHES ON)
    find_package(Vulkan REQUIRED)
    if (Vulkan_FOUND MATCHES TRUE)
        message("Vulkan SDK found.")
        set(RHI_LIBRARIES ${RHI_LIBRARIES} Vulkan::Vulkan)
    else()
        message("Vulkan SDK not found.  Please make sure it is installed and added to your path.")
    endif()
    
    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        VulkanMemoryAllocator
        SpirvTools
    )

    set(RHI_FILES ${RHI_FILES} ${VULKAN_FILES})
endif()

if(${DX11} MATCHES ON)
    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        DirectXShaderCompiler
        "d3d11.lib"
    )
    set(RHI_FILES ${RHI_FILES} ${DX11_FILES})
endif()

if(${DX12} MATCHES ON)
    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        D3D12MemoryAllocator
    )

    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        "d3d12.lib"
    )

    set(RHI_FILES ${RHI_FILES} ${DX12_FILES})
endif()

if(${APPLE_PLATFORM} MATCHES ON)
    find_library(APPLE_APPKIT AppKit)
    find_library(APPLE_QUARTZCORE QuartzCore)
    find_library(APPLE_IOKIT IOKit)

    set(RHI_LIBRARIES
        ${RHI_LIBRARIES}
        ${APPLE_QUARTZCORE}
        ${APPLE_APPKIT}
        ${APPLE_IOKIT}
    )
endif()

if(${WINDOWS} MATCHES ON)
    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        WinPixEventRuntime
        AGS
        Nvapi
    )

    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        "Xinput9_1_0.lib"
        "ws2_32.lib"
    )

    set(RENDER_DEFINES ${RENDER_DEFINES}
        "_WINDOWS"
    )
endif()