# Renderers

set(RHI_SOURCE_DIR ${ENGINE_SOURCE_DIR}/RHI)

set(RHI_SOURCE_FILES
    ${RHI_SOURCE_DIR}/*.cpp
)

set(RHI_INCLUDE_FILES
    ${RHI_SOURCE_DIR}/Interfaces/*.h
)

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

set(DX11_FILES
    ${RHI_SOURCE_DIR}/Direct3D11/*.cpp
)

set(DX12_FILES
    ${RHI_SOURCE_DIR}/Direct3D12/*.cpp
)

set(VULKAN_FILES
    ${RHI_SOURCE_DIR}/Vulkan/*.cpp
)

if(${METAL} MATCHES ON)
    find_library(APPLE_METAL Metal)
    find_library(APPLE_METALKIT MetalKit)
    find_library(APPLE_METALPS MetalPerformanceShaders)

    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        ${APPLE_METAL}
        ${APPLE_METALKIT}
        ${APPLE_METALPS}
    )

    set(RENDERER_FILES ${RENDERER_FILES} ${METAL_FILES})
endif()

if(${VULKAN} MATCHES ON)
    find_package(Vulkan REQUIRED)
    if (Vulkan_FOUND MATCHES TRUE)
        message("Vulkan SDK found.")
        set(RENDER_LIBRARIES ${RENDER_LIBRARIES} Vulkan::Vulkan)
    else()
        message("Vulkan SDK not found.  Please make sure it is installed and added to your path.")
    endif()
    
    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        VulkanMemoryAllocator
        SpirvTools
    )

    set(RENDERER_FILES ${RENDERER_FILES} ${VULKAN_FILES})
endif()

if(${DX11} MATCHES ON)
    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        DirectXShaderCompiler
        "d3d11.lib"
    )
    set(RENDERER_FILES ${RENDERER_FILES} ${DX11_FILES})
endif()

if(${DX12} MATCHES ON)
    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        D3D12MemoryAllocator
    )

    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        "d3d12.lib"
    )

    set(RENDERER_FILES ${RENDERER_FILES} ${DX12_FILES})
endif()

if(${APPLE_PLATFORM} MATCHES ON)
    find_library(APPLE_APPKIT AppKit)
    find_library(APPLE_QUARTZCORE QuartzCore)
    find_library(APPLE_IOKIT IOKit)

    set(RENDER_LIBRARIES
        ${RENDER_LIBRARIES}
        ${APPLE_QUARTZCORE}
        ${APPLE_APPKIT}
        ${APPLE_IOKIT}
    )
endif()

if(${WINDOWS} MATCHES ON)
    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        WinPixEventRuntime
        AGS
        Nvapi
    )

    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        "Xinput9_1_0.lib"
        "ws2_32.lib"
    )

    set(RENDER_DEFINES ${RENDER_DEFINES}
        "_WINDOWS"
    )
endif()
