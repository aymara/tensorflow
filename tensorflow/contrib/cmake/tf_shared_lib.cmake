# Copyright 2017 The TensorFlow Authors. All Rights Reserved.
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
if(WIN32)
  # Windows: build a static library with the same objects as tensorflow.dll.
  # This can be used to build for a standalone exe and also helps us to
  # find all symbols that need to be exported from the dll which is needed
  # to provide the tensorflow c/c++ api in tensorflow.dll.
  # From the static library we create the def file with all symbols that need to
  # be exported from tensorflow.dll. Because there is a limit of 64K sybmols
  # that can be exported, we filter the symbols with a python script to the namespaces
  # we need.
  #
  add_library(tensorflow_static STATIC
      $<TARGET_OBJECTS:tf_c>
      $<TARGET_OBJECTS:tf_cc>
      $<TARGET_OBJECTS:tf_cc_framework>
      $<TARGET_OBJECTS:tf_cc_ops>
      $<TARGET_OBJECTS:tf_cc_while_loop>
      $<TARGET_OBJECTS:tf_core_lib>
      $<TARGET_OBJECTS:tf_core_cpu>
      $<TARGET_OBJECTS:tf_core_framework>
      $<TARGET_OBJECTS:tf_core_ops>
      $<TARGET_OBJECTS:tf_core_direct_session>
      $<TARGET_OBJECTS:tf_tools_transform_graph_lib>
      $<$<BOOL:${tensorflow_ENABLE_GRPC_SUPPORT}>:$<TARGET_OBJECTS:tf_core_distributed_runtime>>
      $<TARGET_OBJECTS:tf_core_kernels>
      $<$<BOOL:${tensorflow_ENABLE_GPU}>:$<TARGET_OBJECTS:tf_core_kernels_cpu_only>>
      $<$<BOOL:${tensorflow_ENABLE_GPU}>:$<TARGET_OBJECTS:tf_stream_executor>>
  )

  add_dependencies(tensorflow_static tf_protos_cc)
  set(tensorflow_static_dependencies
      $<TARGET_FILE:tensorflow_static>
      $<TARGET_FILE:tf_protos_cc>
  )

  if(${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
    set(tensorflow_deffile "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}/tensorflow.def")
  else()
    set(tensorflow_deffile "${CMAKE_CURRENT_BINARY_DIR}/tensorflow.def")
  endif()
  set_source_files_properties(${tensorflow_deffile} PROPERTIES GENERATED TRUE)
  math(EXPR tensorflow_target_bitness "${CMAKE_SIZEOF_VOID_P}*8")
  add_custom_command(TARGET tensorflow_static POST_BUILD
      COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/tools/create_def_file.py
          --input "${tensorflow_static_dependencies}"
          --output "${tensorflow_deffile}"
          --target tensorflow-for-lima.dll
          --bitness "${tensorflow_target_bitness}"
  )
endif(WIN32)

# tensorflow is a shared library containing all of the
# TensorFlow runtime and the standard ops and kernels.
add_library(tensorflow-for-lima SHARED
    $<TARGET_OBJECTS:tf_c>
    $<TARGET_OBJECTS:tf_cc>
    $<TARGET_OBJECTS:tf_cc_framework>
    $<TARGET_OBJECTS:tf_cc_ops>
    $<TARGET_OBJECTS:tf_cc_while_loop>
    $<TARGET_OBJECTS:tf_core_lib>
    $<TARGET_OBJECTS:tf_core_cpu>
    $<TARGET_OBJECTS:tf_core_framework>
    $<TARGET_OBJECTS:tf_core_ops>
    $<TARGET_OBJECTS:tf_core_direct_session>
    $<TARGET_OBJECTS:tf_tools_transform_graph_lib>
    $<$<BOOL:${tensorflow_ENABLE_GRPC_SUPPORT}>:$<TARGET_OBJECTS:tf_core_distributed_runtime>>
    $<TARGET_OBJECTS:tf_core_kernels>
    $<$<BOOL:${tensorflow_ENABLE_GPU}>:$<$<BOOL:${BOOL_WIN32}>:$<TARGET_OBJECTS:tf_core_kernels_cpu_only>>>
    $<$<BOOL:${tensorflow_ENABLE_GPU}>:$<TARGET_OBJECTS:tf_stream_executor>>
    ${tensorflow_deffile}
)

target_link_libraries(tensorflow-for-lima PRIVATE
    ${tf_core_gpu_kernels_lib}
    ${tensorflow_EXTERNAL_LIBRARIES}
    tf_protos_cc
)

# There is a bug in GCC 5 resulting in undefined reference to a __cpu_model function when
# linking to the tensorflow library. Adding the following libraries fixes it.
# See issue on github: https://github.com/tensorflow/tensorflow/issues/9593
if(CMAKE_COMPILER_IS_GNUCC AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.0)
    target_link_libraries(tensorflow-for-lima PRIVATE gcc_s gcc)
endif()

if(WIN32)
  add_dependencies(tensorflow-for-lima tensorflow_static)
endif(WIN32)

target_include_directories(tensorflow-for-lima PUBLIC
    $<INSTALL_INTERFACE:include/>)

install(TARGETS tensorflow-for-lima EXPORT tensorflow_export
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib)

install(EXPORT tensorflow_export
        FILE TensorflowConfig.cmake
        DESTINATION lib/cmake)

# install necessary headers
# tensorflow headers
install(DIRECTORY ${tensorflow_source_dir}/tensorflow/cc/
        DESTINATION include/tensorflow/cc
        FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/tensorflow/cc/
        DESTINATION include/tensorflow/cc
        FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${tensorflow_source_dir}/tensorflow/core/
        DESTINATION include/tensorflow/core
        FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/tensorflow/core/
        DESTINATION include/tensorflow/core
        FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${tensorflow_source_dir}/tensorflow/stream_executor/
        DESTINATION include/tensorflow/stream_executor
        FILES_MATCHING PATTERN "*.h")
# google protobuf headers
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src/protobuf/src/google/
        DESTINATION include/google
        FILES_MATCHING PATTERN "*.h")
# Eigen directory
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/eigen/src/eigen/Eigen/
        DESTINATION include/Eigen)
# external directory
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/external/eigen_archive/
        DESTINATION include/external/eigen_archive)
# third_party eigen directory
install(DIRECTORY ${tensorflow_source_dir}/third_party/eigen3/
        DESTINATION include/third_party/eigen3)
# unsupported Eigen directory
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/eigen/src/eigen/unsupported/Eigen/
        DESTINATION include/unsupported/Eigen)


# Package Generator  #######################################################
set(VERSION_MAJOR "1")
set(VERSION_MINOR "9")
set(VERSION_PATCH "0")
set(CPACK_GENERATOR "NSIS")
set(CPACK_NSIS_MODIFY_PATH ON)
set(CPACK_PACKAGE_VERSION_MAJOR "${VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${VERSION_PATCH}")
set(CPACK_PACKAGE_VENDOR "CEA LIST")
set(CPACK_PACKAGE_CONTACT "lima.publisher@tuta.io")
set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")
include (CPack)
