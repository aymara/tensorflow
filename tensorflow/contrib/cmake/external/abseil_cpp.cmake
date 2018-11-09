# Copyright 2018 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
include (ExternalProject)
set(abseil_cpp_URL https://github.com/abseil/abseil-cpp.git)
set(abseil_cpp_TAG "cc4bed2d74f7c8717e31f9579214ab52a9c9c610")
set(abseil_cpp_BUILD ${CMAKE_CURRENT_BINARY_DIR}/abseil_cpp/src/abseil_cpp)
set(abseil_cpp_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/abseil_cpp/src/abseil_cpp)
# DO NOT SUBMIT verify outputs
if(WIN32)
    if(${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
        set(abseil_cpp_STATIC_LIBRARIES ${abseil_cpp_BUILD}/$(Configuration)/abseil_cpp.lib)
    else()
        set(abseil_cpp_STATIC_LIBRARIES ${abseil_cpp_BUILD}/abseil_cpp.lib)
    endif()

    add_compile_options(/wd4005 /wd4068 /wd4244 /wd4267 /wd4800)
    add_definitions(/DNOMINMAX /DWIN32_LEAN_AND_MEAN=1 /D_CRT_SECURE_NO_WARNINGS)
else()
    set(abseil_cpp_STATIC_LIBRARIES ${abseil_cpp_BUILD}/libabseil_cpp.a)
endif()
set(abseil_cpp_HEADERS
    "$(abseil_cpp_INCLUDE_DIR)/*/*.h"
)
ExternalProject_Add(abseil_cpp
    PREFIX abseil_cpp
    DEPENDS cctz
    GIT_REPOSITORY ${abseil_cpp_URL}
    GIT_TAG ${abseil_cpp_TAG}
    DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../../external/abseil_cpp ${CMAKE_CURRENT_BINARY_DIR}/abseil_cpp/src/abseil_cpp
    UPDATE_COMMAND ""
    BUILD_IN_SOURCE 1
    BUILD_BYPRODUCTS ${abseil_cpp_STATIC_LIBRARIES}
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patches/abseil_cpp/CMakeLists.txt ${abseil_cpp_BUILD}
    #BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    CMAKE_CACHE_ARGS
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=${tensorflow_ENABLE_POSITION_INDEPENDENT_CODE}
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
        -DCMAKE_CXX_FLAGS:STRING=-I${CMAKE_CURRENT_BINARY_DIR}/cctz/src/cctz/include/
        -DBUILD_TESTING:BOOL=OFF
        -DSNAPPY_BUILD_TESTS:BOOL=OFF
)
