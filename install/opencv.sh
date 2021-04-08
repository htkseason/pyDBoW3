#!/usr/bin/env bash

CWD=`pwd`
VERSION=3.4.14

git clone https://github.com/opencv/opencv.git opencv3
git clone https://github.com/opencv/opencv_contrib.git opencv3_contrib
cd opencv3_contrib
git checkout $VERSION
cd ../opencv3
git checkout $VERSION

mkdir build
cd build

if [ -z "$OPENCV_INSTALL_LOCALLY" ]; then
  OPENCV_PREFIX="-DCMAKE_INSTALL_PREFIX=/usr/local"
else
  OPENCV_PREFIX="-DCMAKE_INSTALL_PREFIX=$CWD/opencv3"
fi

if [ "$BUILD_PYTHON" = "python3" ]; then
    echo "Building OpenCV with Python3 support"

    PYTHON_INTERP=$(which python3)
    PYTHON_LIBS=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
    PYTHON_INCLUDES=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")

    cmake -DCMAKE_BUILD_TYPE=RELEASE \
           $OPENCV_PREFIX \
          -DOPENCV_EXTRA_MODULES_PATH=$CWD/opencv3_contrib/modules \
          -DWITH_CUDA=OFF \
          -DCUDA_FAST_MATH=ON \
	  -DOPENCV_ENABLE_NONFREE=ON \
          -DWITH_OPENGL=OFF \
          -DWITH_OPENCL=ON \
	  -DBUILD_WITH_DEBUG_INFO=OFF \
          -DENABLE_FAST_MATH=ON \
          -DBUILD_TIFF=ON \
          -DWITH_CSTRIPES=ON \
          -DWITH_EIGEN=ON \
	  -DWITH_QT=OFF \
          -DWITH_GTK=OFF \
          -DWITH_IPP=ON \
          -DWITH_TBB=OFF \
          -DWITH_OPENMP=ON \
          -DWITH_V4L=ON \
          -DWITH_GSTREAMER=OFF \
          -DWITH_VTK=OFF \
          -DBUILD_opencv_java=OFF \
          -DBUILD_EXAMPLES=OFF \
          -DBUILD_opencv_apps=OFF \
          -DBUILD_DOCS=OFF \
          -DBUILD_PERF_TESTS=OFF \
          -DBUILD_TESTS=OFF \
          -DBUILD_opencv_dnn=OFF \
          -DBUILD_opencv_xfeatures2d=ON \
          -DBUILD_opencv_python2=OFF \
          -DBUILD_opencv_python3=ON \
          -DBUILD_NEW_PYTHON_SUPPORT=ON \
          -DPYTHON_DEFAULT_EXECUTABLE=$PYTHON_INTERP \
          -DPYTHON2_EXECUTABLE=$PYTHON_INTERP \
          -DPYTHON2_INCLUDE_DIR=$PYTHON_INCLUDES \
          -DPYTHON2_PACKAGES_PATH=$PYTHON_LIBS \
          -DPYTHON3_EXECUTABLE=$PYTHON_INTERP \
          -DPYTHON3_INCLUDE_DIR=$PYTHON_INCLUDES \
          -DPYTHON3_PACKAGES_PATH=$PYTHON_LIBS \
          ..
    make -j4 || exit 1
    sudo make install
else
    echo "Building OpenCV with Python2 support"
    cmake -DCMAKE_BUILD_TYPE=RELEASE \
          -DCMAKE_INSTALL_PREFIX=$CWD/opencv3 \
          -DOPENCV_EXTRA_MODULES_PATH=$CWD/opencv3_contrib/modules \
          -DWITH_CUDA=OFF \
          -DCUDA_GENERATION=Kepler \
          -DWITH_CUBLAS=ON \
          -DCUDA_FAST_MATH=ON \
          -DWITH_NVCUVID=ON \
          -DWITH_OPENGL=OFF \
          -DWITH_OPENCL=OFF \
          -DENABLE_AVX=ON \
          -DENABLE_FAST_MATH=ON \
          -DBUILD_TIFF=ON \
          -DWITH_CSTRIPES=ON \
          -DWITH_EIGEN=OFF \
          -DWITH_IPP=ON \
          -DWITH_TBB=ON \
          -DWITH_OPENMP=ON \
          -DENABLE_SSE42=ON \
          -DWITH_V4L=ON \
          -DWITH_VTK=OFF \
          -DBUILD_opencv_java=OFF \
          -DBUILD_EXAMPLES=OFF \
          -DBUILD_opencv_apps=OFF \
          -DBUILD_DOCS=OFF \
          -DBUILD_PERF_TESTS=OFF \
          -DBUILD_TESTS=OFF \
          -DBUILD_opencv_dnn=OFF \
          -DBUILD_opencv_xfeatures2d=ON \
          -DBUILD_opencv_python2=ON \
          -DPYTHON_EXECUTABLE=$(which python) \
          -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
          -DPYTHON_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
          ..
    make -j12 || exit 1
    sudo make install
fi
