����׼��
VPS
�����԰�����ECSΪ��������ϵͳΪCentOS7��64λ����
����
��һ�����������������������VPS�������ϡ����罫*.ngrok.tanxin.tech������VPS��IP��Ҫע�⣬��ʱ����Ҫ��ngrok.tanxin.tech��A��¼����ΪVPS��IP��
������ص�ַ��
    go�����ص�ַ��http://www.golangtc.com/download
    git�����ص�ַ��http://git-scm.com/downloads �������ص�ַ��  https://www.kernel.org/pub/software/scm/git/git-2.6.0.tar.gz
    ngrok��¡��ַ��https://github.com/inconshreveable/ngrok.git
׼��ӳ���������ngrok.tanxin.tech
��װgit
1����װgit���Ұ�װ����2.6�汾����ֹ�������һ�����󣬰�װgit����Ҫ��������
1.      yum -y install zlib-devel openssl-devel perl hg cpio expat-devel gettext-devel curl curl-devel perl-ExtUtils-MakeMaker hg wget gcc gcc-c++
2������git
        wget https://www.kernel.org/pub/software/scm/git/git-2.6.0.tar.gz
3����ѹgit
        tar zxvf git-2.6.0.tar.gz
4������git
               cd git-2.6.0
        ./configure --prefix=/usr/local/git
        make
        make install
5������git��������
               ln -s /usr/local/git/bin/* /usr/bin
��װgo����
׼��go�������ҵ�ϵͳ��64λ��centos����������amd64�İ���32λ������386�İ����ɣ�
1������go�������
               wget https://www.kernel.org/pub/software/scm/git/git-2.6.0.tar.gz
��ѹ�����������ָ��λ��
               tar -zxvf go1.4.2.linux-amd64.tar.gz
        mv go /usr/local/��*����˴��ƶ�ʧ�� ��ʹ���ȸ��Ƶ���Ŀ¼��ɾ���ķ�����
2��go��������Ҫ�������ӵ�/usr/bin
               ln -s /usr/local/go/bin/* /usr/bin
����ngrok
cd /usr/local/
git clone https://github.com/inconshreveable/ngrok.git
export GOPATH=/usr/local/ngrok/
export NGROK_DOMAIN="xxx.XXXX.xxx"��*�˴���Ϊ���Լ����������ɣ�
cd ngrok
Ϊ��������֤��
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_DOMAIN" -days 5000 -out rootCA.pem
openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 5000
�����Դ����Ŀ¼���������һЩ֤���ļ���������Ҫ����Щ�ļ�������ָ��λ��
cp rootCA.pem assets/client/tls/ngrokroot.crt
cp server.crt assets/server/tls/snakeoil.crt
cp server.key assets/server/tls/snakeoil.key
�޸Ĵ���
������˵��������һ��ֱ�ӽ��к����ı��빤��û��ʲô���⡣��������google�޷����ʣ���ɱ����ʱ���code.google.com���Զ�����������log4go��ʱ������ʧ�ܡ�
���ԣ�������Ҫ�������������ص�ַ��Ϊgithub�ϵĵ�ַ
        vi /usr/local/ngrok/src/ngrok/log/logger.go
�������иĳ������
        log "github.com/keepeye/log4go"
ָ�����뻷�����������ȷ��GOOS��GOARCH������ͨ��go env���鿴
��������
cd /usr/local/go/src
GOOS=linux GOARCH=amd64 ./make.bash
cd /usr/local/ngrok/
GOOS=linux GOARCH=amd64 make release-server
����ͻ��ˣ����Լ��Ŀͻ���ѡ����뼴�ɣ�
������mac os 64λ����ϵͳ
cd /usr/local/go/src
GOOS=darwin GOARCH=amd64 ./make.bash
cd /usr/local/ngrok/
GOOS=darwin GOARCH=amd64 make release-client
������Windows�Ŀͻ��˱���
cd /usr/local/go/src
GOOS=windows GOARCH=amd64 ./make.bash
cd /usr/local/ngrok/
GOOS=windows GOARCH=amd64 make release-client
�ͻ��������ļ����½�ngrok.cfg����������Ϣճ����ȥ���У�
server_addr: "xxx.xxxx.xx:4443"
trust_host_root_certs: false 
���������
1.      /usr/local/ngrok/bin/ngrokd -domain="$NGROK_DOMAIN" -httpAddr=":8888"
�ͻ���ʹ��
./ngrok -config=./ngrok.cfg -subdomain=blog 80
setsid ./ngrok -config=./ngrok.cfg -subdomain=test 80 #��linux��������̨����
�����������˵��������Ҫ��װhg
package code.google.com/p/log4go: exec: "hg": executable file not found in $PATH
����취
               yum install hg -y
���뵽 go get gopkg.in/yaml.v1 ��ʱ��ס�����ˣ�˵����git�Ƚϵͣ��汾��Ҫ����1.7.9.5����
fatal: Unable to find remote helper for 'https' ����������⣬�������°�װ curl curl-devel Ȼ������װgit
��װgit-core
wget https://www.kernel.org/pub/software/scm/git/git-core-0.99.6.tar.gz
tar zxvf git-core-0.99.6.tar.gz
cd git-core-0.99.6
make prefix=/usr/libexec/git-core install
export PATH=$PATH:/usr/libexec/git-core/


nginx ����:

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




ע��: ����������ǽ 4443 �˿ڿ���
 golangע��汾, ngrok nginx �˿ھ�������
 
 
 
 