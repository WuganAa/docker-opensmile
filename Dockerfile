FROM ubuntu:16.04
# forked from Ben, 2017
# MAINTAINER Ben Leong <cleong@ets.org>
MAINTAINER Gary Feng <gary.feng@gmail.com>

# install basic packages
RUN apt-get update && \
	apt-get install -y \
	automake \
	build-essential \
	checkinstall \
	cmake \
	git \
	libtool \
	pkg-config \
	python-dev \
	python-numpy \
	sshfs \
	unzip \
	v4l-utils \
	wget \
	x264 \
	yasm

# install all the relevant libs
RUN apt-get install -y \
	libopencv-dev libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine2 libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libgtk2.0-dev libmp3lame-dev 	libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev libpng12-dev libtiff5-dev

# download and extract openSMILE
RUN wget http://audeering.com/download/1318/opensmile-2.3.0.tar.gz && \
	tar -xf opensmile-2.3.0.tar.gz -C /usr/local

# download and extract OpenCV
RUN wget https://github.com/opencv/opencv/archive/2.4.13.3.zip && \
	unzip 2.4.13.3.zip -d /usr/local

# install OpenCV first
RUN mkdir -p /usr/local/opencv-2.4.13.3/release && cd /usr/local/opencv-2.4.13.3/release && \
	cmake -G "Unix Makefiles" -DCMAKE_CXX_COMPILER=/usr/bin/g++ CMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_TBB=ON -DBUILD_NEW_PYTHON_SUPPORT=ON -DWITH_V4L=ON -DINSTALL_C_EXAMPLES=ON -DINSTALL_PYTHON_EXAMPLES=ON -DBUILD_EXAMPLES=ON -DWITH_QT=ON -DWITH_OPENGL=ON -DBUILD_FAT_JAVA_LIB=ON -DINSTALL_TO_MANGLED_PATHS=ON -DINSTALL_CREATE_DISTRIB=ON -DINSTALL_TESTS=ON -DENABLE_FAST_MATH=ON -DWITH_IMAGEIO=ON -DBUILD_SHARED_LIBS=OFF -DWITH_GSTREAMER=ON .. && \
	# assuming most machines have 2 cores now
	make all -j2 && \
	make install

# install openSMILE
RUN cd /usr/local/opensmile-2.3.0/ && \
	./buildWithPortAudio.sh -o /usr/local/lib && \
	./buildStandalone.sh -o /usr/local/lib

# set working directory
WORKDIR /usr/local/opensmile-2.3.0/inst/bin
