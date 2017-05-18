#!/bin/sh


 sudo yum install -y wget
 wget http://mirrors.hostingromania.ro/apache.org/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz
 tar -xvf  kafka_2.12-0.10.2.1.tgz
 sudo mv kafka_2.12-0.10.2.1 /opt
 
 sudo useradd kafka
 sudo chown -R kafka. /opt/kafka_2.12-0.10.2.1
 sudo  ln -s /opt/kafka_2.12-0.10.2.1 /opt/kafka
 sudo chown -h kafka.  /opt/kafka

 sudo mkdir /var/lib/kafka/
 sudo chown kafka. /var/lib/kafka/



cat <<EOF > kafka.service
[Unit]
Description=Apache Kafka server (broker)
Documentation=http://kafka.apache.org/documentation.html
Requires=network.target remote-fs.target
After=network.target remote-fs.target zookeeper.service

[Service]
Type=simple
User=kafka
Group=kafka
Environment=JAVA_HOME=/etc/alternatives/jre
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh

[Install]
WantedBy=multi-user.target   
EOF

sudo mv kafka.service /etc/systemd/system/

echo "Need to modify the kafka.configuration with the correct configuration file.An example will be found in this repo."
echo "Look for TO MODIFY comments
#vi /opt/kafka/config/server.properties

sudo systemctl daemon-reload
sudo systemctl start kafka.service
sudo systemctl status kafka.service

sudo systemctl enable kafka.service
