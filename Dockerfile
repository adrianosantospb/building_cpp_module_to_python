FROM nvcr.io/nvidia/l4t-base:r32.6.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y build-essential cmake gcc g++ gdb clang rsync tar && apt-get clean

#COPY docker/dependencies/install_boost.sh /home
#RUN sh /home/install_boost.sh

#WORKDIR /
#RUN mkdir licenses
#COPY docker/dependencies/install_eigen.sh /home
#RUN sh /home/install_eigen.sh
#COPY docker/dependencies/install_opencv.sh /home
#RUN sh /home/install_opencv.sh


# -------------------------------------------------------------------------------------
#   Install tracktorpy
# -------------------------------------------------------------------------------------

# This need to be fixed, external .so library in dist-packages cant been seen by python3 by default...
# ENV LD_LIBRARY_PATH=/usr/local/lib/python3.8/dist-packages/:${LD_LIBRARY_PATH}
# RUN python3 -m pip install tracktorpy==0.0.8 --extra-index-url https://__token__:<your_personal_token>@gitlab.com/api/v4/projects/23282546/packages/pypi/simple

WORKDIR /home/app
RUN apt-get install -y python3-pip
RUN python3 -m pip install --upgrade pip setuptools wheel
RUN apt-get install python3-numpy -y

# Allow cmake to find opencv and the other dependent packages
COPY . /home/app
ENV CMAKE_PREFIX_PATH=/prefix/
RUN pip3 install -v --prefix=/prefix .


# -------------------------------------------------------------------------------------
#   Multistage build
# -------------------------------------------------------------------------------------
# For lowering the image size and ensuring removing source code
#

FROM nvcr.io/nvidia/l4t-base:r32.6.1
COPY --from=0 /licenses /licenses
COPY --from=0 /prefix/ /prefix
COPY --from=0 /usr/lib/aarch64-linux-gnu/libcrypto* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libstdc++* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libm* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libssl* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libjpeg* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libpng16* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libtiff* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libIlmImf* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libtbb* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libz* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libmyelin* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/liblzma* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libjbig* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libHalf* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libIex* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libIlmThread* /usr/lib/aarch64-linux-gnu/
COPY --from=0 /usr/lib/aarch64-linux-gnu/libnvinfer* /usr/lib/aarch64-linux-gnu/

ENV LD_LIBRARY_PATH=/prefix/lib/python3.6/site-packages/:${LD_LIBRARY_PATH}
ENV PYTHONPATH=/prefix/lib/python3.6/:/prefix/lib/python3.6/site-packages/:${PYTHONPATH}
RUN python3 -c "import tracktorpy; print(f'tracktorpy version: {tracktorpy.__version__}')"
