role_name="CalculatorLambdas"
aws iam get-role --role-name $role_name
if [ "$?" -ne "0" ]
then
	aws iam create-role \
		--role-name $role_name \
		--assume-role-policy-document file://iamtrustdocument.json
fi
role_arn=$(aws iam get-role --role-name $role_name --query Role.Arn --output text)

api_name="CalculatorLambdas"


if [ "$(aws apigateway get-rest-apis --query "items[?name==\`$api_name\`].id" --region $REGION)" = "[]" ]
then
	aws apigateway create-rest-api \
		--name $api_name \
		--region $REGION
fi

api_id=$(aws apigateway get-rest-apis \
	--query "items[?name==\`$api_name\`].id" \
	--output text \
	--region $REGION)

parent_resource_id=$(aws apigateway get-resources \
	--rest-api-id $api_id \
	--query "items[?path=='/'].id" \
	--output text \
	--region $REGION)

for endpoint in add subtract multiply divide
do
	if [ "$(aws apigateway get-resources \
		--rest-api-id $api_id \
		--query "items[?path=='/$endpoint'].id" \
		--output text \
		--region $REGION)" = "" ]
	then
		aws apigateway create-resource \
			--rest-api-id $api_id \
			--parent-id $parent_resource_id \
			--path-part $endpoint \
			--region $REGION

		resource_id=$(aws apigateway get-resources \
			--rest-api-id $api_id \
			--query "items[?path=='/$endpoint'].id" \
			--output text \
			--region $REGION)

		aws apigateway put-method \
			--rest-api-id $api_id \
			--resource-id $resource_id \
			--http-method POST \
			--authorization-type NONE\
			--region $REGION

		cd ../services
		zip -r $endpoint.zip $endpoint.js
		aws lambda create-function \
			--function-name $endpoint \
			--runtime nodejs8.10 \
			--role $role_arn \
			--handler $endpoint.compute \
			--zip-file fileb://$endpoint.zip \
			--region $REGION
		rm $endpoint.zip
		cd ../scripts

		lambda_arn=$(aws lambda list-functions \
			--query "Functions[?FunctionName=='$endpoint'].FunctionArn" \
			--output text --region $REGION)

		aws apigateway put-integration \
			--rest-api-id $api_id \
			--resource-id $resource_id \
			--http-method POST \
			--type AWS \
			--integration-http-method POST \
			--uri arn:aws:apigateway:$REGION:lambda:path/2015-03-31/functions/$lambda_arn/invocations \
			--region $REGION

		aws apigateway put-method-response \
			--rest-api-id $api_id \
			--resource-id $resource_id \
			--http-method POST \
			--status-code 200 \
			--response-models "{}" \
			--region $REGION

	 	aws apigateway put-integration-response \
			--rest-api-id $api_id \
			--resource-id $resource_id \
			--http-method POST \
			--status-code 200 \
			--selection-pattern ".*" \
			--region $REGION

		api_arn=$(echo $lambda_arn | sed \
			-e 's/lambda/execute-api/' \
			-e "s/function:$endpoint/$api_id/")

		aws lambda add-permission \
			--function-name $endpoint \
			--statement-id apigateway-$endpoint-test \
			--action lambda:InvokeFunction \
			--principal apigateway.amazonaws.com \
			--source-arn "$api_arn/*/POST/$endpoint" \
			--region $REGION

		aws lambda add-permission \
			--function-name $endpoint \
			--statement-id apigateway-$endpoint-prod \
			--action lambda:InvokeFunction \
			--principal apigateway.amazonaws.com \
			--source-arn "$api_arn/prod/POST/$endpoint" \
			--region $REGION
	fi
done

aws apigateway create-deployment \
	--rest-api-id $api_id \
	--stage-name prod \
	--region $REGION

LAMBDA_API_URL="https://$api_id.execute-api.$REGION.amazonaws.com/prod"
cd ../calculator
nohup gradle bootRun -Pargs=$LAMBDA_API_URL > calculator.log &
