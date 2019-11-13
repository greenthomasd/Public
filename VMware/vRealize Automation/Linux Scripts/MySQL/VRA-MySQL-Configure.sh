#Reference
#https://docs.vmware.com/en/vRealize-Automation/7.4/com.vmware.vra.prepare.use.doc/GUID-F43D76B4-FDC3-4A42-A52A-84F165C14EC4.html

#!/bin/bash

#Setting proxies
export ftp_proxy=${ftp_proxy:-$global_ftp_proxy}
echo "Setting ftp_proxy to $ftp_proxy"

export http_proxy=${http_proxy:-$global_http_proxy}
echo "Setting http_proxy to $http_proxy"

export https_proxy=${https_proxy:-$global_https_proxy}
echo "Setting https_proxy to $https_proxy"

#
# Determine operating system and version 
#
export OS=
export OS_VERSION=

if [ -f /etc/redhat-release ]; then
    # For CentOS the result will be 'CentOS'
    # For RHEL the result will be 'Red'
    OS=$(cat /etc/redhat-release | awk {'print $1'})

    if [ -n $OS ] && [ $OS = 'CentOS' ]; then
        OS_VERSION=$(cat /etc/redhat-release | awk '{print $3}')
    else
        # RHEL
        OS_VERSION=$(cat /etc/redhat-release | awk '{print $7}')
    fi

elif [ -f /etc/SuSE-release ]; then
    OS=SuSE

    MAJOR_VERSION=$(cat /etc/SuSE-release | grep VERSION | awk '{print $3}')
    PATCHLEVEL=$(cat /etc/SuSE-release | grep PATCHLEVEL | awk '{print $3}')

    OS_VERSION="$MAJOR_VERSION.$PATCHLEVEL"

elif [ -f /usr/bin/lsb_release ]; then
    # For Ubuntu the result is 'Ubuntu'
    OS=$(lsb_release -a 2> /dev/null | grep Distributor | awk '{print $3}')
    OS_VERSION=$(lsb_release -a 2> /dev/null | grep Release | awk '{print $2}')

fi

echo "Using operating system '$OS' and version '$OS_VERSION'"

if [ "x${global_http_proxy}" == "x" ] || [ "x${global_https_proxy}" == "x" ] ||
   [ "x${global_ftp_proxy}" == "x" ]; then
   echo ""
   echo "###############################################################"
   echo "#  One or more PROXY(s) not set. Network downloads may fail   #"
   echo "###############################################################"
   echo ""
fi

export PATH=$PATH:$JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
set -e

# Locate the my.cnf file 
my_cnf_file=
if [ -f /etc/my.cnf ]; then 
    my_cnf_file=/etc/my.cnf
elif [ -f /etc/mysql/my.cnf ]; then 
    my_cnf_file=/etc/mysql/my.cnf
fi

if [ "x$my_cnf_file" = "x" ]; then 
    echo "Neither /etc/my.cnf nor /etc/mysql/my.cnf can be found, stopping configuration"
    exit 1
fi

# update mysql configuration to handle big packets
sed -ie "s/\[mysqld\]/\[mysqld\]\n\
max_allowed_packet=$max_allowed_packet/g" $my_cnf_file
# update listening port
sed -ie "s/\[mysqld\]/\[mysqld\]\n\
port=$db_port/g" $my_cnf_file

sed -i "s/port.*=.*[0-9]*/port=$db_port/g" $my_cnf_file

#if [ "x$OS" != "x" ] && [ "$OS" = 'Ubuntu' ]; then
    # Make sure that MySQL is started 
  #  systemctl restart mysqld
#else 
    # set up auto-start on booting
 #   systemctl enable --now mysqld
    # restart mysqld service
   # systemctl start mysqld

    systemctl enable --now mysqld
    systemctl restart mysqld

#fi

# this will assign a password for mysql admin user 'root'
mysqladmin -u $db_root_username password $db_root_password