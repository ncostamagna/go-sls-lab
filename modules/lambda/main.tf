

data "local_file" "foo" {
  filename = var.file_source
}

resource "terraform_data" "local_file_foo" {
  input = data.local_file.foo.content_sha256
}

resource "aws_lambda_function" "lambda" {
  filename      = var.file_source
  function_name = var.function_name
  role          = var.lambda_role
  handler       = var.lambda_handler
  architectures = var.architectures
  runtime       = var.runtime
  timeout       = var.timeout

  lifecycle {
    replace_triggered_by = [
      terraform_data.local_file_foo,
    ]
  }

  environment {
    variables = var.environment
  }
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = var.api_gw_id
  resource_id   = var.api_gw_resource_id
  http_method   = var.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration_lambda" {
  rest_api_id             = var.api_gw_id
  resource_id             = aws_api_gateway_method.proxy.resource_id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

output "aws_api_gateway_integration_lambda" {
    value = aws_api_gateway_integration.integration_lambda
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.api_gw_execution_arn}/*/*"
}