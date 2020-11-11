# Install cloudstorage
RUN apt-get install -qq \
  autoconf \
  fuse3 \
  libcurl4-openssl-dev \
  libfuse3-dev \
  libjsoncpp-dev \
  libmicrohttpd-dev \
  libtinyxml2-dev \
  libtool \
  pkg-config && \
  git clone --depth 1 https://github.com/cloud-computer/libcloudstorage && \
  cd libcloudstorage && \
  ./bootstrap && \
  ./configure --with-curl --with-microhttpd --with-fuse && \
  make -j$(nproc) && \
  make install && \
  echo user_allow_other >> /etc/fuse.conf && \
  mkdir -p $HOME/.config/cloudstorage && \
  mkdir $HOME/cloudstorage
