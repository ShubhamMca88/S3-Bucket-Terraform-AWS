# Generate a random ID for the S3 bucket name
resource "random_id" "bucket_id" {
  byte_length = 8
}

# Create the S3 bucket with the random ID
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "github-s3-${random_id.bucket_id.hex}"
  force_destroy = true
}

# Disallow public access block (override defaults and allow public access)
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false 
  block_public_policy     = false 
  ignore_public_acls      = false 
  restrict_public_buckets = false 
}

# Enable Public Read Access (for website hosting) via Bucket Policy
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  depends_on = [
    aws_s3_bucket_public_access_block.public_access_block
  ]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      },
    ]
  })
}

# Create an S3 bucket object using a local file (index.html)
resource "aws_s3_object" "github-s3-object-data" {
  bucket = aws_s3_bucket.website_bucket.bucket
  source = "./index.html" # Make sure you have an index.html file in your directory
  key    = "index.html"
  content_type = "text/html"
  etag = filemd5("./index.html")
  depends_on = [
    aws_s3_bucket_policy.website_bucket_policy
  ]
}

# Create a dummy error.html (for website configuration)
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  content = "<html><body><h1>Error</h1><p>This is the error page.</p></body></html>"
  content_type = "text/html"
   depends_on = [
    aws_s3_bucket_policy.website_bucket_policy
  ]
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website_bucket.id

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.website_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption with AES256 (default S3 encryption)
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Output the website URL
output "website_url" {
    value = aws_s3_bucket_website_configuration.website.website_endpoint
}