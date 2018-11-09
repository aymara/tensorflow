# Minimum CMake required
cmake_minimum_required(VERSION 3.5)

include_directories("${CMAKE_CURRENT_BINARY_DIR}")
message(STATUS "CBD:${CMAKE_CURRENT_BINARY_DIR}")

file(GLOB_RECURSE abseil_cc_srcs RELATIVE "${CMAKE_CURRENT_BINARY_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/absl/*/*.cc")
file(GLOB_RECURSE abseil_test_srcs RELATIVE "${CMAKE_CURRENT_BINARY_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/absl/*/*test*.cc")
FOREACH(item ${abseil_cc_srcs})
  IF(${item} MATCHES ".*test.*")
    LIST(REMOVE_ITEM abseil_cc_srcs ${item})
  ENDIF(${item} MATCHES ".*test.*")

  IF(${item} MATCHES ".*nonprod.*")
    LIST(REMOVE_ITEM abseil_cc_srcs ${item})
    message(STATUS "exclude nonprod")
  ENDIF(${item} MATCHES ".*mutex_nonprod.*")

ENDFOREACH(item)

message(STATUS "abseil srcs: ${abseil_cc_srcs}")
message(STATUS "abseil test: ${abseil_test_srcs}")

if(MSVC)
    add_compile_options(/wd4005 /wd4068 /wd4244 /wd4267 /wd4800)
    add_definitions(/DNOMINMAX /DWIN32_LEAN_AND_MEAN=1 /D_CRT_SECURE_NO_WARNINGS)
endif()

add_library(abseil_cpp STATIC ${abseil_cc_srcs})
