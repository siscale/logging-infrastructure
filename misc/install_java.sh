#!/bin/sh

sudo yum update -y
sudo yum install java-1.8.0-openjdk.x86_64
echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> /etc/profile
echo "export JRE_HOME=/usr/lib/jvm/jre" >> /etc/profile

sudo source /etc/profile

echo "Java home is set to $JAVA_HOME"
echo "Java version is $(java -version)"




