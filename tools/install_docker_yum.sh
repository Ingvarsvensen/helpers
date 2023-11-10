#!/bin/bash
# Default action
action="install"

# Check for -r parameter to uninstall
if [ "$1" == "-r" ]; then
    action="uninstall"
fi

# Download and source the colors script
wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/colors.sh | bash

# Functions
install() {
    if ! command -v docker &> /dev/null; then
        echo -e "${C_LGn}Docker is not installed. Installing Docker...${RES}"
        sudo yum update -y
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
        echo -e "${C_LGn}Docker installed successfully.${RES}"
    else
        echo -e "${C_LGn}Docker is already installed.${RES}"
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo -e "${C_LGn}Docker Compose is not installed. Installing Docker Compose...${RES}"
        local docker_compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name")
        sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo -e "${C_LGn}Docker Compose installed successfully.${RES}"
    else
        echo -e "${C_LGn}Docker Compose is already installed.${RES}"
    fi
}

uninstall() {
    echo -e "${C_LGn}Uninstalling Docker and Docker Compose...${RES}"
    sudo yum remove -y docker-ce docker-ce-cli containerd.io
    sudo rm -f /usr/local/bin/docker-compose
    echo -e "${C_LGn}Docker and Docker Compose have been uninstalled.${RES}"
}

# Execute action based on parameter
if [ "$action" == "install" ]; then
    install
elif [ "$action" == "uninstall" ]; then
    uninstall
fi

echo -e "${C_LGn}Operation completed.${RES}"
