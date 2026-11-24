#!/bin/bash
yum install httpd -y
echo "test" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd

yum install amazon-cloudwatch-agent -y

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-linux -s