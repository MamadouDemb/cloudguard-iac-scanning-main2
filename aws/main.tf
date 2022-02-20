
#resource "aws_s3_bucket" "foo" {
  #bucket        = "tf-test-trail"
  #force_destroy = true
  #acl           = "public-read"


resource "aws_s3_bucket" "b" {
  bucket = "iac_s3"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "my_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "public-read"
}