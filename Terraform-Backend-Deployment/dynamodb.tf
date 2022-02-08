resource "aws_dynamodb_table" "main_table" {
  name        = "mitchellprivettresume.com-counterdb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key       = "URL_path"

  attribute {
    name = "URL_path"
    type = "S"
  }
}