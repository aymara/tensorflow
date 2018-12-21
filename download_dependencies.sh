mkdir external
pushd external

git clone https://github.com/abseil/abseil-cpp.git abseil_cpp
pushd abseil_cpp
git checkout cc4bed2d74f7c8717e31f9579214ab52a9c9c610
rm -rf .git
popd

wget https://github.com/google/cctz/archive/v2.2.zip && unzip *.zip && rm v2.2.zip
mv cctz-2.2 cctz

wget https://mirror.bazel.build/github.com/NVlabs/cub/archive/1.8.0.zip && unzip *.zip && rm 1.8.0.zip
mv cub-1.8.0 cub

git clone https://github.com/google/double-conversion.git double_conversion
pushd double_conversion
git checkout 5664746
rm -rf .git
popd

wget https://mirror.bazel.build/github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz && tar -xvf *.tar.gz && rm 816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
mv farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45 farmhash

wget https://bitbucket.org/eigen/eigen/get/fd6845384b86.tar.gz && tar -xzf *.tar.gz && rm fd6845384b86.tar.gz
mv eigen-eigen-fd6845384b86 eigen

wget https://mirror.bazel.build/www.kurims.kyoto-u.ac.jp/~ooura/fft.tgz && tar -xvf fft.tgz && rm fft.tgz
mv fft fft2d

wget https://github.com/google/gemmlowp/archive/38ebac7b059e84692f53e5938f97a9943c120d98.zip && unzip *.zip && rm 38ebac7b059e84692f53e5938f97a9943c120d98.zip
mv gemmlowp-38ebac7b059e84692f53e5938f97a9943c120d98 gemmlowp

wget https://mirror.bazel.build/ufpr.dl.sourceforge.net/project/giflib/giflib-5.1.4.tar.gz && tar -xzf *.tar.gz && rm giflib-5.1.4.tar.gz
mv giflib-5.1.4 gif

git clone --recurse-submodules https://github.com/grpc/grpc.git grpc
pushd grpc
git checkout d184fa229d75d336aedea0041bd59cb93e7e267f
rm -rf .git
find external/ -name .git | xargs -I XX rm -rf XX
rm third_party/libcxx/test/std/experimental/filesystem/Inputs/static_test_env/bad_symlink
popd

git clone https://github.com/google/highwayhash.git highwayhash
pushd highwayhash
git checkout be5edafc2e1a455768e260ccd68ae7317b6690ee
rm -rf .git
popd

wget https://mirror.bazel.build/github.com/jemalloc/jemalloc-cmake/archive/jemalloc-cmake.4.3.1.tar.gz && tar -xzf *.tar.gz && rm jemalloc-cmake.4.3.1.tar.gz
mv jemalloc-cmake-jemalloc-cmake.4.3.1 jemalloc

wget https://mirror.bazel.build/www.ijg.org/files/jpegsrc.v9a.tar.gz && tar -xzf *.tar.gz && rm jpegsrc.v9a.tar.gz
mv jpeg-9a jpeg

git clone https://github.com/open-source-parsers/jsoncpp.git jsoncpp
pushd jsoncpp
git checkout 4356d9b
rm -rf .git
popd

wget https://mirror.bazel.build/github.com/LMDB/lmdb/archive/LMDB_0.9.19.tar.gz && tar -xzf *.tar.gz && rm LMDB_0.9.19.tar.gz
mv lmdb-LMDB_0.9.19 lmdb

git clone https://github.com/google/nsync nsync
pushd nsync
git checkout 0559ce013feac8db639ee1bf776aca0325d28777
rm -rf .git
popd

wget https://mirror.bazel.build/github.com/glennrp/libpng/archive/v1.6.34.tar.gz && tar -xvf *.tar.gz && rm v1.6.34.tar.gz
mv libpng-1.6.34 png

git clone https://github.com/google/protobuf.git protobuf
pushd protobuf
git checkout b04e5cba356212e4e8c66c61bbe0c3a20537c5b9
rm -rf .git
popd

git clone https://github.com/google/re2 re2
pushd re2
git checkout e7efc48
rm -rf .git
popd

git clone https://github.com/google/snappy.git snappy
pushd snappy
git checkout 55924d11095df25ab25c405fadfe93d0a46f82eb
rm -rf .git
popd

wget https://mirror.bazel.build/www.sqlite.org/2018/sqlite-amalgamation-3230100.zip && unzip *.zip && rm sqlite-amalgamation-3230100.zip
mv sqlite-amalgamation-3230100 sqlite

git clone https://github.com/madler/zlib zlib
pushd zlib
rm -rf .git
popd

popd
