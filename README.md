# makeffmpeg

This repository contains a shell script to build FFmpeg with various codecs and features, including support for NVIDIA GPU hardware acceleration. The build script installs FFmpeg and its dependencies in a user's home directory.

### About

After following some great guides online to compile ffmpeg from source, I wanted to use hardware support when required, the latest version of ffmpeg and a preference towards H264, H265 and VC9 codecs. A few attempts online resulted in errors or incomplete builds. This build creates an 'all-in-one' set of binaries, which includes ffmpeg, ffplay and ffprobe and installs them. I also bawked my first attept using libmysofa and had to restore my machine due to conflicting libs so this doesn't use it.

### Requisites
```
sudo apt install nvidia-cuda-toolkit libmp3lame-dev libopus-dev libx265-dev gnutls-dev
```
Check that cuda is working, with **$ nvcc --version** and add to path:

```
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
```
### Features
The script builds and installs FFmpeg with the following codecs and features:

GPL codecs and libraries
H.264 video codec (libx264)
H.265 video codec (libx265)
VP8/VP9 video codecs (libvpx)
AAC audio codec (libfdk-aac, note that this codec is not GPL-compatible)
NVIDIA GPU hardware acceleration (CUDA, cuvid, and nvenc)

### Dependencies
The script installs the following dependencies:

autoconf
automake
build-essential
libass-dev
libfreetype6-dev
libsdl2-dev
libtool
libva-dev
libvdpau-dev
libvorbis-dev
libxcb1-dev
libxcb-shm0-dev
libxcb-xfixes0-dev
pkg-config
texinfo
wget
zlib1g-dev

### Usage

1. Clone this repository and navigate to the directory containing the build script:

```
git clone https://github.com/yourusername/custom-ffmpeg-build.git
cd custom-ffmpeg-build

```
2. Make the script executable:
```
chmod +x build_ffmpeg.sh
```
3. Run the script:

```
./build_ffmpeg.sh
```
The script will download and compile the required dependencies and FFmpeg itself. It will also add the FFmpeg binaries to the user's PATH by updating the ~/.profile file.

### Note on NVIDIA GPU Hardware Acceleration
To enable NVIDIA GPU hardware acceleration, you will need to install the NVIDIA CUDA Toolkit and the Video Codec SDK. Follow the instructions in the script comments for the Video Codec SDK header installation.

### License
This project is licensed under the MIT License.
