#!/bin/bash

# Set up the build environment
export WORK_DIR="${HOME}/ffmpeg_build"
export SRC_DIR="${HOME}/ffmpeg_sources"
export BIN_DIR="${HOME}/bin"

mkdir -p "${WORK_DIR}"
mkdir -p "${SRC_DIR}"
mkdir -p "${BIN_DIR}"
cd "${SRC_DIR}"

# Install required dependencies
sudo apt-get update
sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev

# Install NVIDIA Video Codec SDK (if needed)
# Download from: https://developer.nvidia.com/nvidia-video-codec-sdk/download
# Extract and copy the headers to the appropriate system directory, e.g.:
# sudo cp -r Video_Codec_SDK_11.1.5/include/* /usr/local/include

# Build and install nasm
cd "${SRC_DIR}"
wget https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/nasm-2.16.01.tar.gz
tar xzf nasm-2.16.01.tar.gz
cd nasm-2.16.01
./autogen.sh
./configure --prefix="${WORK_DIR}"
make -j$(nproc)
make install

# Build and install libx264 (H.264 support)
cd "${SRC_DIR}"
git clone --depth 1 https://code.videolan.org/videolan/x264.git
cd x264
./configure --prefix="${WORK_DIR}" --bindir="${BIN_DIR}" --enable-static --enable-pic
make -j$(nproc)
make install

# Build and install libx265 (H.265 support)
cd "${SRC_DIR}"
git clone --depth 1 https://bitbucket.org/multicoreware/x265_git.git
cd x265_git/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${WORK_DIR}" -DENABLE_SHARED=off ../../source
make -j$(nproc)
make install

# Build and install libvpx (VP8/VP9 support)
cd "${SRC_DIR}"
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="${WORK_DIR}" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
make -j$(nproc)
make install

# Build and install libfdk-aac (AAC audio codec, note that this codec is not GPL-compatible)
cd "${SRC_DIR}"
git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -fiv
./configure --prefix="${WORK_DIR}" --disable-shared
make -j$(nproc)
make install

# Build and install FFmpeg with the specified codecs and features
cd "${SRC_DIR}"
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="${WORK_DIR}/lib/pkgconfig" ./configure \
  --prefix="${WORK_DIR}" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I${WORK_DIR}/include" \
  --extra-ldflags="-L${WORK_DIR}/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="${BIN_DIR}" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --enable-cuda-nvcc \
  --enable-cuvid \
  --enable-nvenc \
  --enable-libnpp \
  --extra-cflags="-I/usr/local/cuda/include/" \
  --extra-ldflags="-L/usr/local/cuda/lib64/"

make -j$(nproc)
make install

# Add FFmpeg binaries to PATH
echo "export PATH=\"${BIN_DIR}:\${PATH}\"" >> ~/.profile
source ~/.profile


