# WEB DB PRESS vol. 123 HTTP/3 入門をコンテナを作って試した

## curl

- ホスト

``` shell
docker build -t http3-handson-curl .
docker run --rm --it {CONTAINER ID} /bin/bash
```

- コンテナ

``` shell
root@02585f882730:/project/curl# ./src/curl https://google.com --http3 -v
*   Trying 2404:6800:400a:813::200e:443...
* Connect socket 5 over QUIC to 2404:6800:400a:813::200e:443
* Sent QUIC client Initial, ALPN: h3,h3-29,h3-28,h3-27
* quiche: recvfrom() unexpectedly returned -1 (errno: 101, socket 5)
* connect to 2404:6800:400a:813::200e port 443 failed: Network is unreachable
*   Trying 142.250.206.206:443...
* Connect socket 6 over QUIC to 142.250.206.206:443
* Sent QUIC client Initial, ALPN: h3,h3-29,h3-28,h3-27
* Connected to google.com () port 443 (#0)
* h3 [:method: GET]
* h3 [:path: /]
* h3 [:scheme: https]
* h3 [:authority: google.com]
* h3 [user-agent: curl/7.79.0-DEV]
* h3 [accept: */*]
* Using HTTP/3 Stream ID: 0 (easy handle 0x558a287912f0)
> GET / HTTP/3
> Host: google.com
> user-agent: curl/7.79.0-DEV
> accept: */*
>
< HTTP/3 301
< location: https://www.google.com/
< content-type: text/html; charset=UTF-8
< date: Mon, 09 Aug 2021 01:47:55 GMT
< expires: Wed, 08 Sep 2021 01:47:55 GMT
< cache-control: public, max-age=2592000
< server: gws
< content-length: 220
< x-xss-protection: 0
< x-frame-options: SAMEORIGIN
< alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000,h3-T051=":443"; ma=2592000,h3-Q050=":443"; ma=2592000,h3-Q046=":443"; ma=2592000,h3-Q043=":443"; ma=2592000,quic=":443"; ma=2592000; v="46,43"
<
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
* Connection #0 to host google.com left intact
root@02585f882730:/project/curl# 
```

``` shell
root@02585f882730:/project/curl# QLOGDIR=./ ./src/curl https://google.com --http3
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
root@02585f882730:/project/curl# QLOGDIR=./ ./src/curl https://google.com --http3
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
root@02585f882730:/project/curl# 
```

``` shell
root@02585f882730:/project/curl# ls -la *.qlog
-rw-r--r-- 1 root root 14810 Aug  9 01:51 05f838b7728cb9dbee49e2e0acfa0fc49f9d2aed.qlog
-rw-r--r-- 1 root root  1363 Aug  9 01:51 95fa75e7538c59c0ae2bcfe8fec5bc084f6df1ae.qlog
root@02585f882730:/project/curl# 
```

- ホスト

``` shell
docker cp {CONTAINER ID}:/project/curl/05f838b7728cb9dbee49e2e0acfa0fc49f9d2aed.qlog ./
```

- qlogファイルを https://qvis.quictools.info/ へアップロードすることで可視化できる
