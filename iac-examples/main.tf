# INTENTIONALLY INSECURE - for scanner comparison only. Never applied.

provider "aws" {
  region = "us-east-1"
}

# Flaw: public bucket, no encryption, no versioning, no logging
resource "aws_s3_bucket" "bad" {
  bucket = "vidoori-sandbox-bad-bucket"
}

resource "aws_s3_bucket_acl" "bad" {
  bucket = aws_s3_bucket.bad.id
  acl    = "public-read"
}

# Graph test: encryption is configured in a SEPARATE resource.
# A scanner that understands resource relationships should NOT flag missing encryption here.
resource "aws_s3_bucket" "good" {
  bucket = "vidoori-sandbox-good-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "good" {
  bucket = aws_s3_bucket.good.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Flaw: SSH open to the internet
resource "aws_security_group" "bad" {
  name = "sandbox-bad-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Flaw: unencrypted, publicly accessible database
resource "aws_db_instance" "bad" {
  identifier          = "sandbox-bad-db"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "app"
  manage_master_user_password = true
  publicly_accessible = true
  storage_encrypted   = false
  skip_final_snapshot = true
}
