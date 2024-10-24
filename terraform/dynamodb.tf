
# Create DynamoDB table
resource "aws_dynamodb_table" "product_table" {
  name           = "ProductTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ProductID"
  range_key      = "Category"    # Sort key

   attribute {
    name = "ProductID"
    type = "S"   # String type
  }

  attribute {
    name = "Category"
    type = "S"   # String type
  }


  tags = {
    Name = "ProductTable"
  }
}
