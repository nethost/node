# Node.js Images

- development use *-ubuntu;
- production use *-alpine;

## 10.6

```
$ docker build -t=nethost/node:10.6-alpine .
$ docker push nethost/node:10.6-alpine
$ docker pull nethost/node:10.6-alpine

$ docker build -t=nethost/node:10.6-ubuntu .
$ docker push nethost/node:10.6-ubuntu
$ docker pull nethost/node:10.6-ubuntu
```

## 8.12

```
$ docker build -t=nethost/node:8.12-alpine .
$ docker push nethost/node:8.12-alpine
$ docker pull nethost/node:8.12-alpine

$ docker build -t=nethost/node:8.12-ubuntu .
$ docker push nethost/node:8.12-ubuntu
$ docker pull nethost/node:8.12-ubuntu
```

## 6.14

```
$ docker build -t=nethost/node:6.14-alpine .
$ docker push nethost/node:6.14-alpine
$ docker pull nethost/node:6.14-alpine

$ docker build -t=nethost/node:6.14-ubuntu .
$ docker push nethost/node:6.14-ubuntu
$ docker pull nethost/node:6.14-ubuntu
```