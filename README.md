
1  No schema,
2  Use Powershell dynamic to execute.
3  use JSON to transfer data 

# How to deploy?
```shell

OS Version:

lsb_release  -a

Distributor ID: Ubuntu
Description:    Ubuntu 22.04.4 LTS
Release:        22.04
Codename:       jammy


GLIBC Version:
ldd --version
ldd (Ubuntu GLIBC 2.35-0ubuntu3.6) 2.35
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper
```

- Install clickHouse server:

Reference:

https://clickhouse.com/docs/zh/getting-started/install

or use follow code to install:

```shell
sudo apt-get install -y apt-transport-https ca-certificates dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8919F6BD2B48D754

echo "deb https://packages.clickhouse.com/deb stable main" | sudo tee \
    /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update

sudo apt-get install -y clickhouse-server clickhouse-client

sudo service clickhouse-server start
clickhouse-client # or "clickhouse-client --password" if you've set up a password.

```
 
please setting the clickhouse *** password *** to 'Cpp...' ,it not need to update code.


# Setup ClickHouse Database
Create Tables and view
create default database name is :demo
please use follow command to create tables and Views:

```shell
cd src\SQL

sed -i 's/YOUDB/demo/g' *.*

./setupDB.sh
```

- Please change the clickhouse database connection strings
```shell
tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo
username: default
password: Cpp...
database: demo
debug: false or true
```
- compile your code ,recommand to use Windows 10 WSL2:
- Setup WSL2 in windows https://learn.microsoft.com/en-us/windows/wsl/install
- install Go Language https://golang.google.cn/learn/

```shell
git https://github.com/epmpub/ITutoolsv2-master.git
cd src
go build
```

- change API path in the powershell scripts to your domain name or IP Address.  
```shell
cd Windows
find . -type f -name *.ps1 -exec sed -i 's/utools.run/39.108.176.143/g'  {} \;
```
- test
use the follow powershell command to testing api and database if work.

```shell
irm 39.108.176.143/app_sys_sec|iex

# for testing collect log to server.

```

```

# client deploy
Windows platform please execute follow command,it will help to create a scheduler task:

```shell
irm utools.run/newtask2ck|iex
```

If you have any question ,please feel free to contact with me by email:andy.husheng@gmail.com
WeChat: VIPS_AndyHu
