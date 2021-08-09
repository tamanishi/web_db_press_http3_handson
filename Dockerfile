FROM rust:latest
RUN apt-get update && apt-get -y install cmake

WORKDIR /project
RUN git clone https://github.com/cloudflare/quiche --recursive
WORKDIR quiche
RUN cargo build --release --features ffi,pkg-config-meta,qlog
RUN mkdir -p deps/boringssl/src/lib
RUN ln -vnf $(find target/release -name libcrypto.a -o -name libssl.a) deps/boringssl/src/lib

WORKDIR /project
RUN git clone https://github.com/curl/curl
WORKDIR curl
RUN ./buildconf
RUN ./configure LDFLAGS="-Wl,-rpath,$PWD/../quiche/target/release" \
    --with-ssl=$PWD/../quiche/deps/boringssl/src \
    --with-quiche=$PWD/../quiche/target/release
RUN make


