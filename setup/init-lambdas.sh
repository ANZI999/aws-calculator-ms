region="eu-central-1"
role_name="CalculatorLambdas"
aws iam get-role --role-name $role_name
if [ "$?" -ne "0" ]
then
	aws iam create-role \
		--role-name $role_name \
		--assume-role-policy-document file://iamtrustdocument.json
fi
role_arn=$(aws iam get-role --role-name $role_name --query Role.Arn --output text)

api_name="CalculatorLambdaAPI"


if [ "$(aws apigateway get-rest-apis --query "items[?name==\`$api_name\`].id" --region $region)" = "[]" ]
then
	aws apigateway create-rest-api \
		--name $api_name \
		--region $region
fi

api_id=$(aws apigateway get-rest-apis \
	--query "items[?name==\`$api_name\`].id" \
	--output text \
	--region $region)

parent_resource_id=$(aws apigateway get-resources \
	--rest-api-id $api_id \
	--query "items[?path=='/'].id" \
	--output text \
	--region $region)

for endpoint in add subtract multiply divide
do
	if [ "$(aws apigateway get-resources \
		--rest-api-id $api_id \
		--query "items[?path=='/$endpoint'].id" \
		--output text \
		--region $region)" = "" ]
	then
		aws apigateway create-resource \
			--rest-api-id $api_id \
			--parent-id $parent_resource_id \
			--path-part $endpoint \
			--region $region

		resource_id=$(aws apigateway get-resources \
			--rest-api-id $api_id \
			--query "items[?path=='/$endpoint'].id" \
			--output text \
			--region $region)

		aws apigateway put-method \
			--rest-api-id $api_id \
			--resource-id $resource_id \
			--http-method POST \
			--authorization-type NONE\
			--region $region

		cd ../services
		zip -r add.zip add.js
		aws lambda create-function \
			--function-name $endpoint \
			--runtime nodejs8.10 \
			--role $role_arn \
			--handler $endpoint.compute \
			--zip-file fileb://$endpoint.zip \
			--region $region
		rm add.zip
		cd ../setup

		lambda_arn=$(aws lambda list-functions \
			--query "Functions[?FunctionName=='$endpoint'].FunctionArn" \
			--output text --region $region)

		aws apigateway put-integration \
			--rest-api-id $api_id \
			--resource-id $resource_id \
			--http-method POST \
			--type AWS \
			--integration-http-method POST \
			--uri arn:aws:apigateway:$region:lambda:path/2015-03-31/functions/$lambda_arn/invocations \
			--region $region

		aws apigateway put-method-response \
			--rest-api-id $api_id \
			--resource-id $resource_id \
			--http-method POST \
			--status-code 200 \
			--response-models "{}" \
			--region $region

	 	aws apigateway put-integration-response \
			--rest-api-id $api_id \
			--resource-id $resource_id \
			--http-method POST \
			--status-code 200 \
			--selection-pattern ".*" \
			--region $region

		api_arn=$(echo $lambda_arn | sed \
			-e 's/lambda/execute-api/' \
			-e "s/function:$endpoint/$api_id/")

		aws lambda add-permission \
			--function-name $endpoint \
			--statement-id apigateway-$endpoint-test \
			--action lambda:InvokeFunction \
			--principal apigateway.amazonaws.com \
			--source-arn "$api_arn/*/POST/$endpoint" \
			--region $region

		aws lambda add-permission \
			--function-name $endpoint \
			--statement-id apigateway-$endpoint-prod \
			--action lambda:InvokeFunction \
			--principal apigateway.amazonaws.com \
			--source-arn "$api_arn/prod/POST/$endpoint" \
			--region $region
	fi
done

aws apigateway create-deployment \
	--rest-api-id $api_id \
	--stage-name prod \
	--region $region
lambda_api_url="https://$api_id.execute-api.$region.amazonaws.com/prod"

echo "The url for the api is: $lambda_api_url/add"
