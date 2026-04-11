variable "project_name" {
  type = string
}

resource "aws_s3_object" "data_folder" {
  bucket = aws_s3_bucket.bucket.id
  key    = "data/"
}

resource "aws_s3_object" "images_folder" {
  bucket = aws_s3_bucket.bucket.id
  key    = "images/"
}

resource "aws_s3_object" "public_file" {
  bucket = aws_s3_bucket.bucket.id
  key    = "images/sunset.jpg"
  source = "./data/sunset.jpg"

  acl = "public-read"
}

resource "aws_s3_object" "public_file2" {
  bucket = aws_s3_bucket.bucket.id
  key    = "data/users.txt"
  source = "./data/users.txt"

  acl = "public-read"
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "./data/index.html"

  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.bucket.id
  key    = "error.html"
  source = "./data/error.html"

  acl    = "public-read"
  content_type = "text/html"
}