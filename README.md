# docker-nat-server

使用iptables命令实现nat服务器

## 1. 创建overlay网络

````bash
$ docker network create -d overlay --attachable qiyi
````

新建了一个叫qiyi的网络

## 2. 配置swarm

在master host上运行

````bash
$ docker swarm init
To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-1bdjqxa26cnm39s4fmsggailgg6dtntufh948dqex0becihtqh-0vu3hfkjxwzs7mjwkmqle8il6 \
    192.168.0.151:2377
````

master host的ip是`192.168.0.151`

在slave host上运行

````bash
$ docker swarm join \
> --token SWMTKN-1-1bdjqxa26cnm39s4fmsggailgg6dtntufh948dqex0becihtqh-0vu3hfkjxwzs7mjwkmqle8il6 \
> 192.168.0.151:2377
````

## 3. 使用

### 3.1 创建nat server镜像

````bash
$ docker build -t nat-server .
````

### 3.1 启动nat server

````bash
$ docker run -it --name nat-server --network qiyi --cap-add=NET_ADMIN  nat-server
````

这里需要设置`--cap-add=NET_ADMIN`。同时加入刚才创建的`qiyi`网络。

### 3.2 启动swarm网络中的其他container

````bash
$ docker run -it --rm --network qiyi --cap-add=NET_ADMIN <镜像名> bash
````

在container中设置默认路由为`nat-server`

````bash
root@1234567890:/# route del default
root@1234567890:/# route add default gw nat-server
````