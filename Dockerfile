FROM rust:1.72.0-buster

WORKDIR /app

RUN dpkg --add-architecture armhf

RUN apt update
RUN apt install -y\
  libasound2-dev\
  libasound2-dev:armhf\
  g++-arm-linux-gnueabihf

RUN rustup target add armv7-unknown-linux-gnueabihf
RUN rustup toolchain install stable-armv7-unknown-linux-gnueabihf

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc
ENV CC_armv7_unknown_Linux_gnueabihf=arm-linux-gnueabihf-gcc
ENV CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++

ENV PKG_CONFIG_ALLOW_CROSS=1/
ENV PKG_CONFIG_PATH_armv7_unknown_linux_gnueabihf=/usr/lib/arm-linux-gnueabihf/pkgconfig/

COPY . .

CMD ["cargo", "build", "--release", "--target", "armv7-unknown-linux-gnueabihf"]
