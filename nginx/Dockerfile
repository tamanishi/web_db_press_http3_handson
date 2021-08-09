FROM ubuntu:20.04

RUN apt-get update && \
    apt-get -y install tzdata
ENV TZ=Asia/Tokyo

RUN apt-get update && \
    apt-get -y install \
    mercurial \
    ninja-build \
    libpcre3 \
    libpcre3-dev \
    git \
    build-essential \
    cmake \
    golang-go \
    zlib1g-dev

ENV PROJECT_ROOT=/project
ENV CERT_SUBJECT="/C=CO/ST=State/L=Locality/O=Organization/OU=OrganizationalUnit/CN=CommonName"

WORKDIR ${PROJECT_ROOT}

# build boringssl
RUN git clone https://boringssl.googlesource.com/boringssl
WORKDIR boringssl/build
RUN cmake -GNinja ..
RUN ninja

# build nginx
WORKDIR ${PROJECT_ROOT}
RUN hg clone -b quic https://hg.nginx.org/nginx-quic
WORKDIR nginx-quic
RUN ./auto/configure \
    --with-debug \
    --with-http_v3_module  \
    --with-cc-opt="-I../boringssl/include" \
    --with-ld-opt="-L../boringssl/build/ssl -L../boringssl/build/crypto" \
    --prefix=./
RUN make
RUN mkdir logs

# generate certificats
RUN openssl genrsa 2048 > ./conf/server.key
RUN openssl req -new -subj ${CERT_SUBJECT} -key ./conf/server.key > ./conf/server.csr
RUN openssl x509 -days 30 -req -signkey ./conf/server.key < ./conf/server.csr > ./conf/server.crt
COPY nginx.conf ./conf/nginx.conf
