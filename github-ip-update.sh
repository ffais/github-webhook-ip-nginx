#!/bin/bash
#cd /home/ubuntu/jenkins
github=( $(curl -s https://api.github.com/meta | jq -r '.hooks' | sed -E -n 's/.+"(.+)".*/\1/p') )
nginx=( $(sed -nE 's/.*allow (([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2})\;/\1/p' nginx.conf) )
restart=0
for i in ${github[@]}; do
  found=0
  for n in ${nginx[@]}; do
    if [ $i == $n ]; then
     found=1
     echo "trovato"
     echo $i
     echo $n
    fi
  done
  if [ $found -eq 0 ]; then
    cmd="sed -i -e '/#start github-ip/a\' -e '\t\t\t\t\t\tallow $i;' nginx.conf"
    eval $cmd
    echo $?
    restart=1
  fi
done
if [ $restart -eq 1 ]; then
#  docker service update --force jenkins_nginx
echo "restart"
fi
