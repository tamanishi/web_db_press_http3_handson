# [WEB+DB PRESS Vol.123](https://gihyo.jp/magazine/wdpress/archive/2021/vol123 "WEB+DB PRESS Vol.123") 「HTTP/3 入門」 をコンテナを作って試した

## curl

- ビルド・実行

``` shell
web_db_press_http3_handson/curl on  main ❯ docker build --no-cache -t http3-handson-curl .
(省略)
web_db_press_http3_handson/curl on  main ❯ docker run --rm -it http3-handson-curl src/curl https://google.com --http3 -v
*   Trying 2404:6800:400a:80e::200e:443...
* Connect socket 5 over QUIC to 2404:6800:400a:80e::200e:443
* Sent QUIC client Initial, ALPN: h3,h3-29,h3-28,h3-27
* quiche: recvfrom() unexpectedly returned -1 (errno: 101, socket 5)
* connect to 2404:6800:400a:80e::200e port 443 failed: Network is unreachable
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
* Using HTTP/3 Stream ID: 0 (easy handle 0x55857ab262f0)
> GET / HTTP/3
> Host: google.com
> user-agent: curl/7.79.0-DEV
> accept: */*
>
< HTTP/3 301
< location: https://www.google.com/
< content-type: text/html; charset=UTF-8
< date: Mon, 09 Aug 2021 07:46:13 GMT
< expires: Wed, 08 Sep 2021 07:46:13 GMT
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
web_db_press_http3_handson/curl on  main ❯
```

- 通信ログ取得

  - qlogファイルを https://qvis.quictools.info/ へアップロードすることで可視化できる

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

``` shell
web_db_press_http3_handson/curl on  main ❯ docker cp {CONTAINER ID}:/project/curl/05f838b7728cb9dbee49e2e0acfa0fc49f9d2aed.qlog ./
```

## nginx

- ビルド・実行

``` shell
web_db_press_http3_handson/nginx on  main ❯ docker build --no-cache -t http3-handson-nginx .
(省略)
web_db_press_http3_handson/nginx on  main ❯ docker run --rm --ip 172.17.0.2 -it -d http3-handson-nginx:latest objs/nginx -c conf/nginx.conf
95bce1f0a295b3dc7d9a0fe503db199e5634cbcb481e8f4db31b163fa870482c
web_db_press_http3_handson/nginx on  main ❯ 
```

- ↑でビルドしたcurlでアクセス

``` shell
web_db_press_http3_handson/curl on  main ❯ docker run --rm --ip 172.17.0.3 -it http3-handson-curl src/curl https://172.17.0.2 --http3 -v
*   Trying 172.17.0.2:443...
* Connect socket 5 over QUIC to 172.17.0.2:443
* Sent QUIC client Initial, ALPN: h3,h3-29,h3-28,h3-27
* Connected to 172.17.0.2 () port 443 (#0)
* h3 [:method: GET]
* h3 [:path: /]
* h3 [:scheme: https]
* h3 [:authority: 172.17.0.2]
* h3 [user-agent: curl/7.79.0-DEV]
* h3 [accept: */*]
* Using HTTP/3 Stream ID: 0 (easy handle 0x555eaad1e2f0)
> GET / HTTP/3
> Host: 172.17.0.2
> user-agent: curl/7.79.0-DEV
> accept: */*
>
< HTTP/3 200
< server: nginx/1.21.1
< date: Mon, 09 Aug 2021 07:54:24 GMT
< content-type: text/html
< content-length: 612
< last-modified: Mon, 09 Aug 2021 07:19:43 GMT
< etag: "6110d70f-264"
< alt-svc: h3=":443"; ma=60, h3-29=":443"; ma=60,
< accept-ranges: bytes
<
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
* Connection #0 to host 172.17.0.2 left intact
web_db_press_http3_handson/curl on  main ❯
```
