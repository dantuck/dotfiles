abbr -a docker_rm_all "docker ps -a -q | xargs docker rm"
abbr -a docker_rmi_all "docker images -a -q | xargs docker rmi -f"
abbr -a docker_rmi_dangling "docker image prune -af"