#!/bin/sh

display() {
	echo "[Environment setup script] $1"
}

display "Update system started"

sudo apt-get update -y
sudo apt-get upgrade -y

display "Update system finished"

display "Ensure zip has been installed"

if ! hash zip 2>/dev/null; then
	display "Installing zip"
	sudo apt install zip -y
fi

display "Zip is installed"


display "Ensure Java has been installed"

if ! java >/dev/null; then
	display "Installing java"
	sudo apt install openjdk-11-jre-headless -y
fi

display "Java is installed"

display "Ensure gradle has been installed"

if ! gradle >/dev/null; then
	display "Installing gradle"
	yes "" | sudo add-apt-repository ppa:cwchien/gradle
	sudo apt-get update
	sudo apt install gradle -y
fi

display "Gradle is installed"

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
	display "For this step you need to have created a user with 'AdministratorAccess'."

	read -p "AWS Access Key ID: " access_key_id
	read -p "AWS Secret Access Key: " access_key

	aws configure set aws_access_key_id $access_key_id
	aws configure set aws_secret_access_key $access_key
	aws configure set default.region $REGION
fi

display "Aws cli is configured"



