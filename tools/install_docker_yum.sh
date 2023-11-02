#!/bin/bash
# Default variables
dive="false"
function="install"

# Options
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
    case "$1" in
    -h|--help)
        # (snipped for brevity)
        return 0 2>/dev/null; exit 0
        ;;
    -d|--dive)
        dive="true"
        shift
        ;;
    -u|--uninstall)
        function="uninstall"
        shift
        ;;
    *|--)
        break
        ;;
    esac
done

# Functions
install() {
    cd
    if ! docker --version; then
        echo -e "${C_LGn}Docker installation...${RES}"
        sudo yum update -y
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
    fi
    if ! docker-compose --version; then
        echo -e "${C_LGn}Docker Compose installation...${RES}"
        local docker_compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name")
        sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    if [ "$dive" = "true" ] && ! rpm -q dive; then
        echo -e "${C_LGn}Dive installation...${RES}"
        # (snipped for brevity, you may need to find or build a .rpm package for Dive)
    fi
}
uninstall() {
    echo -e "${C_LGn}Docker uninstalling...${RES}"
    sudo rpm -e dive
    sudo systemctl stop docker.service docker.socket
    sudo yum remove -y docker-ce docker-ce-cli containerd.io
    sudo rm -rf /var/lib/docker
    sudo groupdel docker
    # (snipped for brevity, adjust other commands as necessary for yum/dnf)
}

# Actions
$function
echo -e "${C_LGn}Done!${RES}"
