cmake_minimum_required(VERSION 3.13)
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/cmake")

option(ENABLE_LTO "Enable link time optimization" OFF)

project(testproject CXX C ASM)
set(CMAKE_CXX_STANDARD 17)

if(ENABLE_LTO)
    message(STATUS "LTO selected")
    include(CheckIPOSupported)
    check_ipo_supported(RESULT ipo_supported OUTPUT error_msg)
    if(ipo_supported)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    else()
        message(SEND_ERROR "LTO unavailable: ${error_msg}")
    endif()
endif()

add_executable(main main.cpp)
install(TARGETS main DESTINATION bin)
