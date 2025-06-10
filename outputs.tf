output "lambda_function_arn" {
  value       = aws_lambda_function.lambda.arn
  description = "The arn of lambda function"
}
