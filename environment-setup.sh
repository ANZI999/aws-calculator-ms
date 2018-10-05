#!/bin/sh

display() {
	echo "[Environment setup script] $1"
}

display "Update system started"

sudo apt-get update
sudo apt-get upgrade

display "Update system finished"

display "Ensure kops has been installed"

if ! kops >/dev/null; then
	display "Installing kops"
	wget -O kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
	chmod +x kops
	sudo mv kops /usr/local/bin/
fi

display "Kops is installed"

display "Ensure kubectl has been installed"

if ! kubectl >/dev/null; then
	display "Installing kubectl"
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
	chmod +x kubectl
	sudo mv kubectl /usr/local/bin/
fi

display "Kubectl is installed"

display "Ensure aws cli has been installed"

if ! awscli >/dev/null; then
	display "Installing aws cli"
	sudo apt-get install python-pip -y
	sudo pip install awscli
fi

display "Aws cli is installed"

display "Configure aws cli"

aws sts get-caller-identity --output text
if [ "$?" -ne "0" ]; then
	display "AWS needs configuring."
	display "For this step you need to have created a user with 'AdministratorAccess' and 'AmazonS3FullAccess'."
	aws configure
fi

display "Aws cli is configured"



