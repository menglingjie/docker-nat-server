#from swr.cn-north-1.myhuaweicloud.com/quicktech/debian
from debian:9
maintainer "lj_meng@qiyitech.com.cn"
run apt update && apt install -y iptables
copy run.sh /run.sh
entrypoint /run.sh
