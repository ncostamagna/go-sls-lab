
module "lambda" {
  source = "../modules/lambda"

  file_source     = "bin/get/bootstrap.zip"
  function_name   = "sls-example-go"
  lambda_role     = "arn:aws:iam::831117102174:role/lambda-roles"
  lambda_handler  = "bootstrap.handler"
  architectures   = ["x86_64"]
  runtime         = "provided.al2023"
  timeout         = 30
  environment     = {
    foo = "bar"
  }

  method = "GET"
  api_gw_id = aws_api_gateway_rest_api.api_gw.id
  api_gw_resource_id = aws_api_gateway_rest_api.api_gw.root_resource_id
  api_gw_execution_arn = aws_api_gateway_rest_api.api_gw.execution_arn
}

resource "aws_api_gateway_rest_api" "api_gw" {
  name        = "api"
  description = "API Gateway V1"
}

output "api_gw_id" {
  value = aws_api_gateway_rest_api.api_gw.id
}

resource "aws_api_gateway_deployment" "apigw_deployment" {
  depends_on = [
    module.lambda.aws_api_gateway_integration_lambda,
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = "test"
}
