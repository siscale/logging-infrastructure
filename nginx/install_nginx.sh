#/bin/sh

 sudo yum install epel-release
 sudo yum install -y  nginx
 sudo systemctl start nginx
 sudo systemctl status nginx

sudo cat <<EOF > /etc/nginx/conf.d/load_balancer.conf
# Define which servers to include in the load balancing scheme.
# It's best to use the servers' private IPs for better performance and security.
# You can find the private IPs at your UpCloud Control Panel Network section.
stream {
        upstream kafka {
                server 10.100.105.95:9092;
                server 10.100.105.96:9092;
                server 10.100.105.97:9092;
        }


#this should be modified
        upstream udp_servers {
                server 10.100.105.95:9092;
                server 10.100.105.96:9092;
                server 10.100.105.97:9092;
        }
# This server accepts all traffic to port 9092 and passes it to the upstream.
# Notice that the upstream name and the proxy_pass need to match.


        server {
                listen 9092;
                proxy_pass kafka;
                #health_check port=8080;
        }
        server {
                listen     9092 udp;
                #UDP traffic will be proxied to the "udp_servers" upstream grou
                proxy_pass udp_servers;
        }
}
EOF

echo "You will need to modify and comment the line from http server that includes the      #include /etc/nginx/conf.d/*.conf;"

echo "include /etc/nginx/conf.d/load_balancer.conf;" >> /etc/nginx/nginx.conf

