for endpoint in add subtract multiply divide
do
	aws lambda delete-function --function-name $endpoint
done

api_name="CalculatorLambdas"
region="eu-central-1"
api_id=$(aws apigateway get-rest-apis \
	--query "items[?name==\`$api_name\`].id" \
	--output text \
	--region $region)
aws apigateway delete-rest-api --rest-api-id $api_id
