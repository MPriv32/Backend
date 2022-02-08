data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./python/main.py"
  output_path = "./python.main.py.zip"
}

module "myLambda" {
  source  = "mineiros-io/lambda-function/aws"
  version = "~> 0.5.0"

  function_name = "python-function"
  description   = "python"
  filename      = data.archive_file.lambda.output_path
  runtime       = "python3.9"
  handler       = "main.lambda_handler"
  timeout       = 30
  memory_size   = 128
  environment_variables = {
    main_table = "mitchellprivettresume.com-counterdb",
    main_table_key = "URL_path"
  }

  role_arn = module.iam_role.role.arn

}

module "iam_role" {
  source  = "mineiros-io/iam-role/aws"
  version = "~> 0.6.1"

  name = "python-function"

  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]
  policy_statements = [
    {
      version= "2012-10-17"
      sid="LambdaDynamoDbPolicy"
      effect= "Allow",
      actions= [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ]
      resources= [
        aws_dynamodb_table.main_table.arn,
        "${aws_dynamodb_table.main_table.arn}/*"
        ],
        }
  ]
}