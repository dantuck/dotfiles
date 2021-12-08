abbr -a docker_rm_all "docker rm \`docker ps -a -q\`"
abbr -a docker_rmi_all "docker rmi \`docker images -q\`"
abbr -a docker_rmi_dangling "docker rmi \`docker images -qa -f 'dangling=true'\`"