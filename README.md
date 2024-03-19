
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
- change API path in the powershell scripts:
```shell
find . -type f -name *.ps1 -exec sed -i 's/utools.run/<YOUR Domain Name>/g'  {} \;

```


# Setup ClickHouse Database
Create Tables and view
create default database name is :demo
please use follow command to create tables and Views:

```shell
cd src\SQL
./setupDB.sh
```

# client deploy
Windows platform please execute follow command,it will help to create a scheduler task:

```shell
irm utools.run/newtask2ck|iex
```

If you have any question ,please feel free to contact with me by email:andy.husheng@gmail.com
WeChat: VIPS_AndyHu
