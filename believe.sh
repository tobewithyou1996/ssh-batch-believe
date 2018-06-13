#!/bin/bash
#检查本地是否有密钥文件，没有则添加。
./sshkeygen.exp
#循环取出ip和密码
for i in $(cat ./hosts )
do
	#取出ip和密码
	IP=$(echo "${i}" |awk -F":" '{print $1}')
	PW=$(echo "${i}" |awk -F":" '{print $2}')
	#将本地的公钥复制到远程主机
	./sshcopy.exp $IP  $PW
	#将脚本sshkeygen.exp复制到远程主机
	scp -p ./sshkeygen.exp   $IP:/root/
	#远程主机安装expect
	ssh root@$IP "yum install expect -y "
	#远程主机创建密钥文件
	ssh root@$IP "/root/sshkeygen.exp&"
	#将远程主机的公钥添加到本地authorized_keys文件
	ssh root@$IP "cat ~/.ssh/*.pub" >>./authorized_keys
done
#将本地的公钥复制到远程主机
for i in $(cat ./hosts)
do
	 IP=$(echo "${i}" |awk -F":" '{print $1}')
	 #将本地主机的公钥文件添加到authorized_keys文件
	 cat ~/.ssh/*.pub >>./authorized_keys
	 scp ./authorized_keys $IP:~/.ssh/authorized_keys
done 
