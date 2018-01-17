环境准备
VPS
这里以阿里云ECS为例，操作系统为CentOS7（64位）。
域名
将一个域名或二级域名泛解析到VPS服务器上。例如将*.ngrok.tanxin.tech解析到VPS的IP。要注意，此时还需要将ngrok.tanxin.tech的A记录设置为VPS的IP。
软件下载地址：

    go的下载地址：http://www.golangtc.com/download
    git的下载地址：http://git-scm.com/downloads 
    绝对下载地址：  https://www.kernel.org/pub/software/scm/git/git-2.6.0.tar.gz
    ngrok克隆地址：https://github.com/inconshreveable/ngrok.git
准备映射的域名：ngrok.tanxin.tech
安装git
1、安装git，我安装的是2.6版本，防止会出现另一个错误，安装git所需要的依赖包
        yum -y install zlib-devel openssl-devel perl hg cpio expat-devel gettext-devel curl curl-devel perl-ExtUtils-MakeMaker hg wget gcc gcc-c++
2、下载git
        wget https://www.kernel.org/pub/software/scm/git/git-2.6.0.tar.gz
3、解压git
        tar zxvf git-2.6.0.tar.gz
4、编译git
        cd git-2.6.0
        ./configure --prefix=/usr/local/git
        make
        make install
5、创建git的软连接
               ln -s /usr/local/git/bin/* /usr/bin
安装go环境
准备go环境，我的系统是64位的centos所以我下载amd64的包（32位的下载386的包即可）
1、下载go的软件包
               wget https://www.kernel.org/pub/software/scm/git/git-2.6.0.tar.gz
解压出来可以随便指定位置
               tar -zxvf go1.4.2.linux-amd64.tar.gz
               mv go /usr/local/   （*如果此处移动失败 请使用先复制到该目录再删除的方法）
2、go的命令需要做软连接到/usr/bin
               ln -s /usr/local/go/bin/* /usr/bin
编译ngrok
    cd /usr/local/
    git clone https://github.com/inconshreveable/ngrok.git
    export GOPATH=/usr/local/ngrok/
    export NGROK_DOMAIN="xxx.XXXX.xxx"（*此处改为你自己的域名即可）
cd ngrok
为域名生成证书
    openssl genrsa -out rootCA.key 2048
    openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_DOMAIN" -days 5000 -out rootCA.pem
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
    openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 5000
在软件源代码目录下面会生成一些证书文件，我们需要把这些文件拷贝到指定位置
    cp rootCA.pem assets/client/tls/ngrokroot.crt
    cp server.crt assets/server/tls/snakeoil.crt
    cp server.key assets/server/tls/snakeoil.key
修改代码
按理来说，跳过这一步直接进行后续的编译工作没有什么问题。但是由于google无法访问，造成编译的时候从code.google.com上自动下载依赖包log4go超时而编译失败。
所以，我们需要将依赖包的下载地址改为github上的地址
        vi /usr/local/ngrok/src/ngrok/log/logger.go
将第四行改成下面的
        log "github.com/keepeye/log4go"
指定编译环境变量，如何确认GOOS和GOARCH，可以通过go env来查看
编译服务端
    cd /usr/local/go/src
    GOOS=linux GOARCH=amd64 ./make.bash
    cd /usr/local/ngrok/
    GOOS=linux GOARCH=amd64 make release-server
编译客户端（按自己的客户端选择编译即可）
适用于mac os 64位操作系统
    cd /usr/local/go/src
    GOOS=darwin GOARCH=amd64 ./make.bash
    cd /usr/local/ngrok/
    GOOS=darwin GOARCH=amd64 make release-client
适用于Windows的客户端编译
    cd /usr/local/go/src
    GOOS=windows GOARCH=amd64 ./make.bash
    cd /usr/local/ngrok/
    GOOS=windows GOARCH=amd64 make release-client
客户端配置文件（新建ngrok.cfg，将配置信息粘贴进去就行）
    server_addr: "xxx.xxxx.xx:4443"
    trust_host_root_certs: false 
服务端启动
      /usr/local/ngrok/bin/ngrokd -domain="$NGROK_DOMAIN" -httpAddr=":8888"
客户端使用
    ./ngrok -config=./ngrok.cfg -subdomain=blog 80
    setsid ./ngrok -config=./ngrok.cfg -subdomain=test 80 #在linux下如果想后台运行
出现这个错误说明我们需要安装hg
    package code.google.com/p/log4go: exec: "hg": executable file not found in $PATH
解决办法
    yum install hg -y
编译到 go get gopkg.in/yaml.v1 的时候卡住不走了，说明是git比较低，版本需要大于1.7.9.5以上
fatal: Unable to find remote helper for 'https' 出现这个问题，可以重新安装 curl curl-devel 然后再重装git
安装git-core
    wget https://www.kernel.org/pub/software/scm/git/git-core-0.99.6.tar.gz
    tar zxvf git-core-0.99.6.tar.gz
    cd git-core-0.99.6
    make prefix=/usr/libexec/git-core install
    export PATH=$PATH:/usr/libexec/git-core/


nginx 配置:

server
    {
        listen 80;
        server_name *.ngrok.tanxin.com;
        keepalive_timeout 70;
        proxy_set_header "Host" $host:8888;
        location / {
                proxy_pass_header Server;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:8888;
        }
        access_log off;
        log_not_found off;
    } 




注意: 服务器防火墙 4443 端口开启
 golang注意版本, ngrok nginx 端口竞争问题
 
 
 
 
