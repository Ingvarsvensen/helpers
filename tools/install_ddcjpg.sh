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
if [[ -e /etc/debian_version ]]; then
    os="debian"
elif [[ -e /etc/redhat-release ]]; then
    os="redhat"
else
    echo "Unsupported OS"
    exit 1
fi

# Function to install Docker
install_docker_func() {
    if [[ $os == "debian" ]]; then
        sudo apt-get update
        sudo apt-get install -y docker.io
    else
        sudo yum update -y
        sudo yum install -y docker
    fi
}

# Function to install Docker Compose
install_docker_compose_func() {
    if [[ $os == "debian" ]]; then
        sudo apt-get update
        sudo apt-get install -y docker-compose
    else
        sudo yum update -y
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
}

# Function to install Java
install_java_func() {
    if [[ $os == "debian" ]]; then
        sudo apt-get update
        sudo apt-get install -y openjdk-11-jdk
    else
        sudo yum update -y
        sudo yum install -y java-11-openjdk-devel
    fi
}

# Function to install Python
install_python_func() {
    if [[ $os == "debian" ]]; then
        sudo apt-get update
        sudo apt-get install -y python3
    else
        sudo yum update -y
        sudo yum install -y python3
    fi
}

# Function to install Git
install_git_func() {
    if [[ $os == "debian" ]]; then
        sudo apt-get update
        sudo apt-get install -y git
    else
        sudo yum update -y
        sudo yum install -y git
    fi
}

# Install the selected software
[[ $install_docker ]] && install_docker_func
[[ $install_docker_compose ]] && install_docker_compose_func
[[ $install_java ]] && install_java_func
[[ $install_python ]] && install_python_func
[[ $install_git ]] && install_git_func

echo "Installation completed!"
