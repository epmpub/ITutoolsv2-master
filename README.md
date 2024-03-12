说明：
1  无schema,
2  终端采集用脚本,无需编译,动态执行;
3  标准JSON格式



- 部署方式：
```shell

操作系统版本:

lsb_release  -a

Distributor ID: Ubuntu
Description:    Ubuntu 22.04.4 LTS
Release:        22.04
Codename:       jammy


GLIBC版本:
ldd --version
ldd (Ubuntu GLIBC 2.35-0ubuntu3.6) 2.35
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper
```


GO LANG 编译环境和部署主机最好一致.推荐是使用WSL2 Ubuntu22


- Install clickHouse server:

参考:
https://clickhouse.com/docs/zh/getting-started/install
 


- 修改代码clickhouse 连接字符串;
```shell
tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo
其中:
default为用户名
Cpp...为密码
database为数据库名
请替换成你自己的配置.
另外,为了安全,不要在公网暴露你的数据库.
```

```shell
git https://github.com/epmpub/ITutoolsv2-master.git
cd API
go build
```

- 创建clickhouse表和view

数据库默认为demo
建表参考 :create-clickhouse-table
View参考:create-clickhouse-view

### client
Windows:
```shell
irm utools.run/newtask2ck|iex
```

Linux 和 MacOS 参考windows脚本,写一个定时任务即可.

部署中肯定会有各种奇怪的问题,如果你觉得很麻烦,可以微信我.
我可以远程指导你部署.
WeChat: VIPS_AndyHu
