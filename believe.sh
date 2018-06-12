./sshkeygen.exp
for i in $(cat ./hosts )
do
	
	IP=$(echo "${i}" |awk -F":" '{print $1}')
	PW=$(echo "${i}" |awk -F":" '{print $2}')
	./sshcopy.exp $IP  $PW
	scp -p ./sshkeygen.exp   $IP:/root/
	#./ssh2.exp $IP
	ssh root@$IP "yum install expect -y "
	ssh root@$IP "/root/sshkeygen.exp&"
	ssh root@$IP "cat ~/.ssh/*.pub" >>./authorized_keys
done
for i in $(cat ./hosts)
do
	 IP=$(echo "${i}" |awk -F":" '{print $1}')
	 scp ./authorized_keys $IP:~/.ssh/authorized_keys
done 
