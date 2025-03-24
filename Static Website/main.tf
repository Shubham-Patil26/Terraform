#Specifies AWS as the provider and sets the region to "us-east-1"
provider "aws" { 
  region = "us-east-1"  
}


#Creates an S3 bucket named "my-static-website-bucket-00001" with tags "Name": "MyStaticWebsite-1" and "Environment": "Dev".
resource "aws_s3_bucket" "website1" { 
  bucket = "my-static-website-bucket-00001"

  tags = {
    Name        = "MyStaticWebsite-1"
    Environment = "Dev"
  }
}



#Configures the S3 bucket to host a static website, using "index.html" as the default page.
resource "aws_s3_bucket_website_configuration" "website-1" {
  bucket = aws_s3_bucket.website1.id

  index_document {
    suffix = "index.html"
  }

}


#Sets a public access policy for the S3 bucket to allow everyone to read the objects in it (e.g., allow access to "index.html")
resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.website1.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.website1.id}/*"
    }
  ]
}
EOF
}

#Modifies the S3 bucket's public access settings to allow public access, despite other public access blocks.
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website1.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


#Uploads a file called "index.html" from your local system to the S3 bucket, setting its content type to "text/html".
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website1.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}