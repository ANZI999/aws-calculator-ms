role_name="CalculatorLambdas"
aws iam get-role --role-name $role_name
if [ "$?" -ne "0" ]
then
	aws iam create-role --role-name $role_name --assume-role-policy-document file://iamtrustdocument.json
fi
role_arn=$(aws iam get-role --role-name $role_name --query Role.Arn)

api_name="CalculatorLambdaAPI"

