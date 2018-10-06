#!/bin/sh

display() {
	echo "[Environment setup script] $1"
}

display "Update system started"

sudo apt-get update
sudo apt-get upgrade

display "Update system finished"

display "Ensure zip has been installed"

if ! zip >/dev/null; then
	display "Installing zip"
	sudo apt install zip -y
fi

display "Zip is installed"

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



