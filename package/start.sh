#########################################################################
# File Name: start.sh
# Author: nys 
# mail: nys@guazi.com
# Created Time: Mon 05 Jun 2017 05:55:42 PM CST
#########################################################################
#!/bin/bash
/etc/init.d/supervisor start
sleep 3

tail -f /var/log/supervisor/nginx.log
