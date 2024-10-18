# RGPScan

轻量级内网资产探测漏洞扫描工具

## 简介

RGPScan是一款支持弱口令爆破的内网资产探测漏洞扫描工具，集成了Xray与Nuclei的Poc

### 工具定位

内网资产探测、通用漏洞扫描、弱口令爆破、端口转发、内网穿透、SOCK5

- 主机[IP&域名]存活检测，支持PING/ICMP模式
- 端口[IP&域名]服务扫描
- 网站爬虫截图，CMS识别
- Nuclei & Xray POC
- 网卡识别、域控识别、SMBGhost、MS17017
- 弱口令爆破：
    - 文件：FTP/SMB
    - 远程：SSH/RDP/SNMP
    - 数据库：Redis/MongoDB/MySQL/SQLServer/PgSQL/ES/Oracle/Memcached
- TCP端口转发
- 内网穿透
- SOCK5穿透

### 免责声明

本工具只可用于安全测试，勿用于非法用途！

### 一、编译

- 递归克隆项目，获取最新poc

```shell
git clone https://github.com/rustgopy/RGPScan.git --recursive
```

- 初始化module

```shell
go mod tidy
go mod vendor
```

- Windows

```shell
set GOOS=windows
set GOARCH=amd64
go build -ldflags="-s -w" -trimpath -o RGPScan.exe

set GOOS=windows
set GOARCH=386
go build -ldflags="-s -w" -trimpath -o RGPScan.exe
```

- Mac or Linux

```shell
GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -trimpath -o RGPScan
GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w" -trimpath -o RGPScan
GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -trimpath -o RGPScan
GOOS=linux GOARCH=386 go build -ldflags="-s -w" -trimpath -o RGPScan
```

### 二、运行

- 自动扫描

```shell
./RGPScan
```

- 根据指定IP段扫描

```shell
./RGPScan -h=192.168.188.1/24
```

- 根据指定IP+端口扫描

```shell
./RGPScan -h=192.168.188.1/24 -p=tiny
./RGPScan -h=192.168.188.1/24,10.0.0.1/16 -p=22,80,443
```

- 根据指定IP段混合域名扫描

```shell
./RGPScan -h=192.168.188.1/24,10.0.0.1/24,www.a.com,www.b.xyz,www.c.net
```

- 修改并发提高性能

```shell
./RGPScan -wsh=2048 -wsp=1024 -h=192.168.188.1/24,10.0.0.1/16 -p=22,80,443
```

- 跳过主机存活检测（nsh）、POC漏洞探测（nsp）、弱口令爆破（nsw）、高危漏洞探测（nsv）

```shell
./RGPScan -h=192.168.188.1/24 -p=22,80 --nsh --nsp --nsw --nsv
```

- 指定IP文件、密码文件、账号文件、输出excel文件、指定爆破协议

```shell
./RGPScan -h=ip.txt -wp=pass.txt -wu=user.txt -oe=test.xlsx -ot=test.txt -ssw=redis,ssh,mysql
```

- 弱口令生成器（覆盖模式iwp、追加模式iap）

```shell
./RGPScan -h=192.168.188.1/24 -iwp -pp=test,Test -pc=@ -ps=123
```

- 端口转发

```shell
./RGPScan --pf -sh=192.168.188.1:8080 -lp=8080
```

- 内网穿透公网服务器端启动，启动端口默认9188可自定义

```shell
./RGPScan --pm --pms -secret=自定义密码
```

- 内网客户端端口映射，TCP端口转发

```shell
./RGPScan --pm --pmc -secret=自定义密码 -su=公网IP:9188 -pcm=8081-127.0.0.1:8080,8082-127.0.0.1:8080,8088-192.168.166.55:80
```

```text
127.0.0.1:8080 映射到 公网8081
127.0.0.1:8080 映射到 公网8082
192.168.166.55:80 映射到 公网8088
```

- 内网Sock5穿透

```shell
./RGPScan --pm --pmc --pmcs -secret=自定义密码 -su=公网IP:9188
```

### 三、参数

- 查看参数帮助命令

> ./RGPScan --help

```text
Usage:
  ./RGPScan [flags]

Flags:
   -il, -isLog                         显示日志 (default true)
   -is, -isScreen                      启用截图 (default true)
   -oe, -outputExcel string            指定保存excel文件路径[以.xlsx结尾]
   -ot, -outputTxt string              指定保存txt文件路径[以.txt结尾]
   -h, -host string                    检测网段/域名，或者txt文件[以.txt结尾，一行一组回车换行] (default "192.168.0.0/16,172.16.0.0/12,10.0.0.0/8")
   -p, -port string                    端口范围：tiny[精简]、web[WEB服务]、normal[常用]、database[数据库]、caffe[咖啡厅/酒店/机场]、iot[物联网]、all[全部]、自定义 (default "web")
   -pt, -protocol string               端口范围：tcp、udp、tcp+udp (default "tcp+udp")
   -hb, -hostBlack string              排除网段
   -msh, -methodScanHost string        验存方式：PING、ICMP (default "ICMP")
   -wsh, -workerScanHost int           存活并发 (default 250)
   -tsh, -timeOutScanHost int          存活超时 (default 3)
   -r, -rarity int                     优先级 (default 10)
   -wsp, -workerScanPort int           扫描并发 (default 250)
   -tspc, -timeOutScanPortConnect int  端口扫描连接超时 (default 6)
   -tsps, -timeOutScanPortSend int     端口扫描发包超时 (default 6)
   -tspr, -timeOutScanPortRead int     端口扫描读取超时 (default 6)
   -inpo, -isNULLProbeOnly             使用空探针，默认使用自适应探针
   -iuap, -isUseAllProbes              使用全量探针，默认使用自适应探针
   -wss, -workerScanSite int           爬虫并发 (default 16)
   -tss, -timeOutScanSite int          爬虫超时 (default 6)
   -ts, -timeOutScreen int             截图超时 (default 60)
   -lpn, -listPocNuclei                列举Poc Nuclei
   -lpx, -ListPocXray                  列举Poc Xray
   -fpn, -filterPocName string         筛选POC名称，多个关键字英文逗号隔开
   -fvl, -filterVulLevel string        筛选POC严重等级：critical[严重] > high[高危] > medium[中危] > low[低危] > info[信息]、unknown[未知]、all[全部]，多个关键字英文逗号隔开
   -tspn, -timeOutScanPocNuclei int    PocNuclei扫描超时 (default 6)
   -wsPoc, -workerScanPoc int          Poc并发 (default 100)
   -gsw, -groupScanWeak int            爆破分组 (default 20)
   -wsw, -workerScanWeak string        爆破并发，键值对形式，英文逗号分隔 (default "ssh:1,smb:1,rdp:1,snmp:1,sqlserver:4,mysql:4,mongodb:4,postgres:4,redis:6,ftp:1,clcsearch:4,oracle:4,memcached:4")
   -tsw, -timeOutScanWeak int          爆破超时 (default 6)
   -nsh, -noScanHost                   跳过主机存活检测
   -nsw, -noScanWeak                   跳过弱口令爆破
   -nsp, -noScanPoc                    跳过POC漏洞验证
   -nsv, -noScanVul                    跳过高危系统漏洞探测
   -ssw, -serviceScanWeak string       指定爆破协议：ssh,smb,rdp,snmp,sqlserver,mysql,mongodb,postgres,redis,ftp,clickhouse,elasticsearch,oracle,memcached，多个协议英文逗号分隔，默认全部
   -au, -aUser string                  追加弱口令账号字典[以.txt结尾]
   -ap, -aPass string                  追加弱口令密码字典[以.txt结尾]
   -wu, -wUser string                  覆盖弱口令账号字典[以.txt结尾]
   -wp, -wPass string                  覆盖弱口令密码字典[以.txt结尾]
   -iap, -isAPass                      追加弱口令生成器
   -iwp, -isWPass                      覆盖弱口令生成器
   -pp, -passwordPrefix string         密码前缀，多个英文逗号分隔
   -pc, -passwordCenter string         密码中位，多个英文逗号分隔
   -ps, -passwordSuffix string         密码后缀，多个英文逗号分隔
   -pf, -portForward                   开启端口转发
   -sh, -sourceHost string             目标转发主机
   -lp, -localPort int                 本机代理端口
   -pm, -portMap                       开启内网穿透
   -pmc, -portMapClient                开启内网穿透-客户端
   -pms, -portMapServer                开启内网穿透-服务端
   -pmcs, -portMapClientSock5          开启内网穿透-客户端Sock5
   -s, -secret string                  穿透密钥，自定义 (default "RGPScan")
   -psl, -portServerListen int         穿透服务端监听端口 (default 9188)
   -sp, -sock5Port int                 Sock5监听端口 (default 9189)
   -sau, -sock5AuthUsername string     Sock5鉴权账号
   -sap, -sock5AuthPassword string     Sock5鉴权密码
   -su, -serverUri string              穿透服务端地址，公网IP:端口
   -pcm, -portClientMap string         穿透客户端映射字典，多个英文逗号隔开，格式：8080-127.0.0.1:8080,9000-192.168.188.1:9000
```

### 四、更新日志

<details>
  <summary>更新日志👇🏻点击展开</summary>

```text
2023-03-08（v0.1.1）
    [+]迁移到自己的仓库维护
2022-07-03（v0.1.0）
    [+]更新nuclei
    [x]修复端口扫描解析指纹库数组越界bug
2022-06-24（v0.0.9）
    [+]1.域名存活检测
    [+]2.域名端口服务扫描
    [+]3.更新弱口令
    [+]4.更新nuclei
    [+]5.新增截图目录
2022-06-20（v0.0.8）
    [+]1.Oracle爆破
    [+]2.Memcached爆破
    [+]3.RDP远程桌面爆破
2022-06-15（v0.0.7）
    [+]1.端口转发
    [+]2.内网TCP端口映射转发/内网穿透
    [+]3.Sock5代理/内网穿透
    [+]4.新增Linux ARM编译，可结合termux在安卓端运行
2022-06-09（v0.0.6）
    [+]1.弱口令生成器
    [+]2.支持excel+txt文件导出
    [+]3.http跳转资产探测
    [+]4.更新nuclei
    [+]5.ICMP自动检测，无权限切换为PING，默认ICMP
    [x]6.IP洗牌改成4字节整型，降低占用内存
    [x]7.修复弱口令爆破并发过高丢包bug，协程泄漏问题，增加自定义指定协议并发数
2022-06-06（v0.0.5）
    [+]1.自定义输出文件
    [+]2.自定义爆破协议
    [+]3.自定义爆破账号密码文件（支持追加模式和覆盖模式）
    [+]4.自定义IP文件
2022-06-01（v0.0.4）
    [x]1.修复POC Xray扫描引擎
    [x]2.修复外网是否可以达？可达下载chrome并截图
    [x]3.修复临时文件无法删除bug
    [+]4.优化进度条
    [+]5.新增跳过（主机存活、弱口令、POC、高危漏洞）参数
2022-05-29（v0.0.3）
    [x]1.修改弱口令爆破阻塞bug
    [x]2.优化进度条显示
2022-05-28（v0.0.2）
    [+]1.网卡识别
    [+]2.域控识别
    [+]3.MS17010漏洞探测
    [+]4.SMBGhost漏洞探测
    [+]5.POC Xray V2漏洞探测
    [+]6.POC Nuclei V2漏洞探测
    [+]7.弱口令爆破
        * FTP爆破
        * SSH爆破
        * SMB爆破
        * SNMP爆破
        * Redis爆破
        * MongoDB爆破
        * MySQL爆破
        * SQLServer爆破
        * PostGreSQL爆破
        * ElasticSearch爆破
    [+]8.结果存储到Excel
2022-05-20（v0.0.1）
    [+]1.主机存活检测（PING｜ICMP）
    [+]2.端口服务扫描（高精度探针指纹识别）
    [+]3.网站指纹爬虫（站点截图、CMS识别）
```

</details>

### 五、参考项目

- 致谢🙏🙏🙏

```text
1.nuclei：https://github.com/projectdiscovery/nuclei
2.xray：https://github.com/chaitin/xray
```

#### 六、联系作者

- 作者：张金龙
- 微信：rustgopy
- Q Q：1780316635
- 邮箱：thznote@qq.com
- 博客：rustgopy.com
- GitHub：github.com/rustgopy

#### 七、我的媒体

- [我的B站](https://space.bilibili.com/477557902)
- [我的CSDN](https://edu.csdn.net/lecturer/2759)
- [我的虎课网](https://huke88.com/teacher/21640415.html)
- [我的课课家](https://www.kokojia.com/school-10076699.html)
- [我的腾讯课堂](https://thz.ke.qq.com/)
- [我的网易云课堂](https://study.163.com/provider/1026051425/course.htm)
- [我的51CTO学堂](https://edu.51cto.com/lecturer/14114771.html)

#### 八、微信二维码

![微信](image/wx.jpeg)

## Stargazers over time

[![Stargazers over time](https://starchart.cc/rustgopy/RGPScan.svg)](https://starchart.cc/rustgopy/RGPScan)


