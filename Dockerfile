FROM docker.io/alpine:3.12 AS build

ENV MSITOOLS_VERSION=0.100

RUN apk add --no-cache -t makedeps \
    gcc \
    libc-dev \
    glib-dev \
    libgsf-dev \
    libgcab-dev \
    bison \
    make \
    && \
    mkdir -p /build/vroot /build/source

RUN wget -qO- https://download.gnome.org/sources/msitools/${MSITOOLS_VERSION}/msitools-${MSITOOLS_VERSION}.tar.xz | \
    tar -xJ --strip-components 1 -C /build/source/

RUN cd /build/source/ && \
    ./configure --disable-dependency-tracking --prefix=/build/vroot && \
    make && make install

FROM docker.io/alpine:3.12

RUN apk add --no-cache \
    glib \
    libgcab \
    libgsf \
    libgsf \
    libuuid

COPY --from=build /build/vroot/ /usr/local/