### 软件特色：

##### 使用简单,无需学习;

##### 全面支持Windows，Linux，macOS

##### 简化工作，减少重复，提升工作效率

##### 不需要安装部署任何客户端

##### 高度定制自己的专门站点

##### 迭代快速,紧跟业务;

##### Don't repeat yourself


### 使用介绍：
使用管理员权限，打开POWERSHELL 终端，输入如下命令：
```powershell
irm utools.run/win | iex
```

![test](utools.png)


TestCast /API/data:
### ToMongoDB

```powershell
$dt = @{}
$dt['$date'] = Get-Date -f "o"

# test for API ,not for file export.
$info = [ordered]@{}
$info["Timestamp"]=Get-Date -f "o"
$info["Host"]=$env:COMPUTERNAME
$info["Cpu"]=(Get-CimInstance -ClassName Win32_Processor).Caption
$jsdata=$info | convertTo-Json
$jsdata

$jsdata | Out-File 666.json -Encoding utf8

Invoke-RestMethod http://utools.run/data -Method Post -Body $jsdata

```