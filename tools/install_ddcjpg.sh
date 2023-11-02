#!/bin/bash

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -d, --docker         Install Docker"
    echo "  -dc, --docker-compose Install Docker Compose"
    echo "  -j, --java           Install Java"
    echo "  -p, --python         Install Python"
    echo "  -g, --git            Install Git"
    echo "  -v, --version        Specify version (e.g., -v 3.8.1)"
    echo "  -h, --help           Show help"
    exit 0
}

# Default version setting (empty for latest version)
version=""

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--docker) install_docker=true ;;
        -dc|--docker-compose) install_docker_compose=true ;;
        -j|--java) install_java=true ;;
        -p|--python) install_python=true ;;
        -g|--git) install_git=true ;;
        -v|--version) version="$2"; shift ;;
        -h|--help) show_help ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Detect the OS
os=""
if grep -q 'ID=ubuntu' /etc/os-release; then
    os="ubuntu"
elif grep -q 'ID=centos' /etc/os-release || grep -q 'ID_LIKE="centos rhel fedora"' /etc/os-release; then
    os="centos"
elif grep -q 'ID="amzn"' /etc/os-release; then
    os="amazon"
else
    echo "Unsupported OS"
    exit 1
fi

install_docker_func() {
    case $os in
        ubuntu)
            sudo apt-get update
            sudo apt-get install -y docker.io
            ;;
        centos|amazon)
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $(whoami)
            ;;
        *)
            echo "Unsupported OS for Docker installation"
            exit 1
            ;;
    esac
}

install_docker_compose_func() {
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
}

install_java_func() {
    case $os in
        ubuntu)
            sudo apt-get update
            sudo apt-get install -y openjdk-11-jdk
            ;;
        centos|amazon)
            sudo yum update -y
            sudo yum install java-11-openjdk-devel -y
            ;;
        *)
            echo "Unsupported OS for Java installation"
            exit 1
            ;;
    esac
}

install_python_func() {
    case $os in
        ubuntu)
            sudo apt-get update
            sudo apt-get install -y python3
            ;;
        centos|amazon)
            sudo yum update -y
            sudo yum install python3 -y
            ;;
        *)
            echo "Unsupported OS for Python installation"
            exit 1
            ;;
    esac
}

install_git_func() {
    case $os in
        ubuntu)
            sudo apt-get update
            sudo apt-get install -y git
            ;;
        centos|amazon)
            sudo yum update -y
            sudo yum install git -y
            ;;
        *)
            echo "Unsupported OS for Git installation"
            exit 1
            ;;
    esac
}

# Install the selected software
[[ $install_docker ]] && install_docker_func
[[ $install_docker_compose ]] && install_docker_compose_func
[[ $install_java ]] && install_java_func
[[ $install_python ]] && install_python_func
[[ $install_git ]] && install_git_func

echo "Installation completed!"
