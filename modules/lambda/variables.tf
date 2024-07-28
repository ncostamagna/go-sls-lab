variable "file_source" {
  description = "The path to the zip file"
  type        = string
}

variable "function_name" {
  description = "The name of the lambda function"
  type        = string
}

variable "lambda_role" {
  description = "The ARN of the role"
  type        = string
}

variable "lambda_handler" {
  description = "The handler of the lambda function"
  type        = string
}

variable "architectures" {
  description = "The architectures of the lambda function"
  type        = list(string)
}

variable "runtime" {
  description = "The runtime of the lambda function"
  type        = string
}

variable "timeout" {
  description = "The timeout of the lambda function"
  type        = number
}

variable "environment" {
  description = "The environment variables of the lambda function"
  type        = map(string)
}

variable "method" {
  description = "The HTTP method"
  type        = string
}
variable "api_gw_id" {
  description = "The ID of the API Gateway"
  type        = string
}

variable "api_gw_resource_id" {
  description = "The ID of the API Gateway resource"
  type        = string
}

variable "api_gw_execution_arn" {
  description = "The ARN of the API Gateway execution"
  type        = string
}