# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.18)

project(detection_plugin_library VERSION 0.0.1 LANGUAGES C CXX)

get_filename_component(MY_PROJ ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)

# packages

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(ncnn_DIR "${MY_PROJ}/linux/ncnn-20230517-ubuntu-2204-shared/lib/cmake")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Android")
    set(ncnn_DIR "${MY_PROJ}/android/ncnn-20240102-android-vulkan-shared/${ANDROID_ABI}/lib/cmake/ncnn")
# elseif(CMAKE_SYSTEM_NAME STREQUAL "APPLE")

else()
    message(FATAL_ERROR "system not support: ${CMAKE_SYSTEM_NAME}")
endif()

if(NOT EXISTS ${ncnn_DIR})
    message(FATAL_ERROR "ncnn_DIR not exists: ${ncnn_DIR}")
endif()

## ncnn

find_package(ncnn REQUIRED)
message(STATUS "ncnn_FOUND: ${ncnn_FOUND}")


# targets

include_directories(
        ${MY_PROJ}/src
)

## ncnn_yolox


add_library(detection_plugin SHARED
  "detection_plugin.cpp"
)

target_link_libraries(detection_plugin ncnn)

set_target_properties(detection_plugin PROPERTIES
  PUBLIC_HEADER detection_plugin.h
  OUTPUT_NAME "detection_plugin"
)

target_compile_definitions(detection_plugin PUBLIC DART_SHARED_LIB)


