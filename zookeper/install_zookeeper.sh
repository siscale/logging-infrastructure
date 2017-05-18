#!/bin/sh

 wget http://apache.org/dist/zookeeper/current/zookeeper-3.4.10.tar.gz
 tar xvf zookeeper-3.4.10.tar.gz
 sudo mv zookeeper-3.4.10 /opt
 sudo useradd zookeeper
 sudo chown -R zookeeper. /opt/zookeeper-3.4.10/
 sudo ln -s /opt/zookeeper-3.4.10/ /opt/zookeeper
 sudo chown -h zookeeper. /opt/zookeeper
 sudo mkdir /var/lib/zookeeper
 sudo chown zookeeper. /var/lib/zookeeper/
 
 echo $1 > myid
 sudo mv myid /var/lib/zookeeper/
 
cat <<EOF > zookeeper.service
[Unit]
Description=Apache Zookeeper server
Documentation=http://zookeeper.apache.org
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=forking
User=zookeeper
Group=zookeeper
ExecStart=/opt/zookeeper/bin/zkServer.sh start
ExecStop=/opt/zookeeper/bin/zkServer.sh stop
ExecReload=/opt/zookeeper/bin/zkServer.sh restart
WorkingDirectory=/var/lib/zookeeper

[Install]
WantedBy=multi-user.target     
EOF


echo "Please edit this script with the correct ip's of your cluster.Script will exit."
exit 1
cat <<EOF> /opt/zookeeper/conf/zoo.cfg
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=5
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=2
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/var/lib/zookeeper
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
#TO MODIFY
#server.1=10.100.105.150:2666:3666
#server.2=10.100.105.151:2666:3666
#server.3=10.100.105.152:2666:3666
EOF
sudo mv zookeeper.service /etc/systemd/system/

