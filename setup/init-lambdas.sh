region="eu-central-1"
role_name="CalculatorLambdas"
aws iam get-role --role-name $role_name
if [ "$?" -ne "0" ]
then
	aws iam create-role --role-name $role_name --assume-role-policy-document file://iamtrustdocument.json
fi
role_arn=$(aws iam get-role --role-name $role_name --query Role.Arn)

api_name="CalculatorLambdaAPI"


if [ "$(aws apigateway get-rest-apis --query "items[?name==\`$api_name\`].id" --region $region)" = "[]" ]
then
	aws apigateway create-rest-api --name $api_name --region $region
fi

api_id=$(aws apigateway get-rest-apis --query "items[?name==\`$api_name\`].id" --output text  --region $region)
echo $api_id

parent_resource_id=$(aws apigateway get-resources --rest-api-id $api_id --query "items[?path=='/'].id" --output text --region $region)
echo $parent_resource_id

for endpoint in add
do
	if [ "$(aws apigateway get-resources --rest-api-id $api_id --query "items[?path=='/$endpoint'].id" --output text --region $region)" = "" ]
	then
		aws apigateway create-resource --rest-api-id $api_id --parent-id $parent_resource_id --path-part $endpoint --region $region
	fi

	resource_id=$(aws apigateway get-resources --rest-api-id $api_id --query "items[?path=='/$endpoint'].id" --output text --region $region)
	echo $resource_id

	aws apigateway put-method \
		--rest-api-id $api_id \
		--resource-id $resource_id \
		--http-method POST \
		--authorization-type NONE\
		--region $region

	aws lambda create-function \
		--function-name $endpoint \
		--runtime nodejs8.10 \
		--role $role_arn \
		--handler $endpoint.compute \
		--zip-file fileb://igor.zip \
		--region $region
done
