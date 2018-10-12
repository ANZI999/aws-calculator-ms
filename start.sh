
read -p "Application region: " REGION
export REGION

cd scripts
sh environment-setup.sh
sh start-application.sh
