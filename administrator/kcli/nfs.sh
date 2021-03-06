yum -y install nfs-utils
for i in `seq -f "%03g" 1 60` ; do
mkdir /pv${i}
echo "/pv$i *(rw,no_root_squash)"  >>  /etc/exports
chcon -t svirt_sandbox_file_t /pv${i}
chmod 777 /pv${i}
done
exportfs -r
systemctl start nfs ; systemctl enable nfs-server
export HOME=/root
oc login -u system:admin
for i in `seq 1 20` ; do j=`printf "%03d" ${i}` ; sed "s/001/$j/" /root/nfs.yml | oc create -f - ; done
