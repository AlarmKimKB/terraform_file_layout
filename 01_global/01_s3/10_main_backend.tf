provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "scott_s3_bucket" {
  bucket = "terraform-study-tfstate"
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "scott_s3_bucket_versioning" {
  bucket = aws_s3_bucket.scott_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "scott_dynamodb_table" {
  name         = "terraform-locks-files"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
