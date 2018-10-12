In order to run this project you need a running AWS EC2 instance (Can be t2.micro) with Ubuntu Server 18.04 LTS
which has its port 8080 opened and also enabled ssh (Last one should be default).

In addition you must have created a user through IAM which has Programmatic access and 
"AdministratorAccess" permission.
Also you should write down the displayed "Access key ID" and "Secret Access key" as you
have to input them in the future.

Once EC2 instance is running ssh yourself into it and clone current repository.
Then go into the folder by running "cd aws-lambda-based-calculator"

The last step is running "sh start.sh" which creates the lambda functions and starts the application
server. If asked input the region where the instance is running and also the user credentials to access
aws.

To use the application copy from EC2 instance list "Public DNS" of the instance. 
And go to the address 
{publicDNS}:8080/{operation}/number1/number2<br />
List of operations:<br />
add<br />
subtract<br />
multiply<br />
divide

If you want to reset everything run "sh stop.sh" that will delete all the created resources 
on aws and stop the application server
