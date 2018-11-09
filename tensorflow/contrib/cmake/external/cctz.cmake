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
include (ExternalProject)

set(cctz_URL https://github.com/google/cctz/archive/v2.2.zip)
set(cctz_HASH SHA256=fde7695558c951b6c486fec3e6010c88cedba0511ae77e39ab29d2e9b04baf37)
set(cctz_BUILD ${CMAKE_CURRENT_BINARY_DIR}/cctz/src/cctz)
set(cctz_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/cctz/src/cctz/include)
set(cctz_ARCHIVE_DIR ${CMAKE_CURRENT_BINARY_DIR}/external/cctz_archive)

ExternalProject_Add(cctz
    PREFIX cctz
    URL ${cctz_URL}
    URL_HASH ${cctz_HASH}
    DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../../external/cctz ${CMAKE_CURRENT_BINARY_DIR}/cctz/src/cctz
    UPDATE_COMMAND ""
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND  ${CMAKE_COMMAND} -E copy_directory  ${cctz_INCLUDE_DIR}/cctz ${cctz_ARCHIVE_DIR}/cctz
    CMAKE_CACHE_ARGS
         -DBUILD_EXAMPLES:BOOL=OFF
         -DBUILD_TESTING:BOOL=OFF
)
