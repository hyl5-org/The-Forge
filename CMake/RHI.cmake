# RHI

set(RHI_INTERFACE_DIR ${ENGINE_RUNTIME_SOURCE_DIR}/RHI/Public)
set(RHI_SOURCE_DIR ${ENGINE_RUNTIME_SOURCE_DIR}/RHI/Private)


file(GLOB RHI_INTERFACE_FILES ${RHI_INTERFACE_DIR}/RHI/*.h ${RHI_INTERFACE_DIR}/RHI/*.hpp)


file(GLOB_RECURSE DX11_INCLUDE_FILES ${RHI_SOURCE_DIR}/Direct3D11/*.h ${RHI_SOURCE_DIR}/Direct3D11/*.hpp)
file(GLOB_RECURSE DX11_SOURCE_FILES ${RHI_SOURCE_DIR}/Direct3D11/*.cpp ${RHI_SOURCE_DIR}/Direct3D11/*.c)

file(GLOB_RECURSE DX12_INCLUDE_FILES ${RHI_SOURCE_DIR}/Direct3D12/*.h ${RHI_SOURCE_DIR}/Direct3D12/*.hpp)
file(GLOB_RECURSE DX12_SOURCE_FILES ${RHI_SOURCE_DIR}/Direct3D12/*.cpp ${RHI_SOURCE_DIR}/Direct3D12/*.c)

file(GLOB_RECURSE VULKAN_INCLUDE_FILES ${RHI_SOURCE_DIR}/Vulkan/**.cpp ${RHI_SOURCE_DIR}/Vulkan/**.c)
file(GLOB_RECURSE VULKAN_SOURCE_FILES ${RHI_SOURCE_DIR}/Vulkan/**.h ${RHI_SOURCE_DIR}/Vulkan/**.hpp)

file(GLOB RHI_INCLUDE_FILES ${RHI_SOURCE_DIR}/*.h ${RHI_SOURCE_DIR}/*.hpp)
file(GLOB RHI_SOURCE_FILES ${RHI_SOURCE_DIR}/*.cpp ${RHI_SOURCE_DIR}/*.c)


if(${METAL} MATCHES ON)
    find_library(APPLE_METAL Metal)
    find_library(APPLE_METALKIT MetalKit)
    find_library(APPLE_METALPS MetalPerformanceShaders)

    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        ${APPLE_METAL}
        ${APPLE_METALKIT}
        ${APPLE_METALPS}
    )

    set(RHI_SOURCE_FILES ${RHI_SOURCE_FILES} ${METAL_FILES})
endif()

if(${VULKAN} MATCHES ON)
    find_package(Vulkan REQUIRED)
    if (Vulkan_FOUND MATCHES TRUE)
        message("Vulkan SDK found.")
        set(RHI_LIBRARIES ${RHI_LIBRARIES} Vulkan::Vulkan)
        #add_definitions(VULKANSDKFOUND)
    else()
        message("Vulkan SDK not found.  Please make sure it is installed and added to your path.")
    endif()
    
    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        VulkanMemoryAllocator
        SpirvTools
    )
    set(RHI_INCLUDE_FILES ${RHI_INCLUDE_FILES} ${VULKAN_INCLUDE_FILES})
    set(RHI_SOURCE_FILES ${RHI_SOURCE_FILES} ${VULKAN_SOURCE_FILES})
endif()

if(${DX11} MATCHES ON)
    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        DirectXShaderCompiler
        "d3d11.lib"
    )
    set(RHI_INCLUDE_FILES ${RHI_INCLUDE_FILES} ${DX11_INCLUDE_FILES})
    set(RHI_SOURCE_FILES ${RHI_SOURCE_FILES} ${DX11_SOURCE_FILES})
endif()

if(${DX12} MATCHES ON)
    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        D3D12MemoryAllocator
    )

    set(RHI_LIBRARIES ${RHI_LIBRARIES}
        "d3d12.lib"
    )
    set(RHI_INCLUDE_FILES ${RHI_INCLUDE_FILES} ${DX12_INCLUDE_FILES})
    set(RHI_SOURCE_FILES ${RHI_SOURCE_FILES} ${DX12_SOURCE_FILES})
endif()

# if(${APPLE_PLATFORM} MATCHES ON)
#     find_library(APPLE_APPKIT AppKit)
#     find_library(APPLE_QUARTZCORE QuartzCore)
#     find_library(APPLE_IOKIT IOKit)

#     set(RHI_LIBRARIES
#         ${RHI_LIBRARIES}
#         ${APPLE_QUARTZCORE}
#         ${APPLE_APPKIT}
#         ${APPLE_IOKIT}
#     )
# endif()

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