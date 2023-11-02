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
		sudo yum install curl yum-utils device-mapper-persistent-data lvm2 -y
		sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		sudo yum install docker-ce docker-ce-cli containerd.io -y
	fi
	if ! docker-compose --version; then
		# (snipped for brevity)
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
	# (snipped for brevity, adjust other commands as necessary for yum/dnf)
}

# Actions
$function
echo -e "${C_LGn}Done!${RES}"
