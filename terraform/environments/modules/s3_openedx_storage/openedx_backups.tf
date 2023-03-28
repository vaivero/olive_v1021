#------------------------------------------------------------------------------
# written by: Miguel Afonso
#             https://www.linkedin.com/in/mmafonso/
#
# date: Aug-2021
#
# usage: create an AWS S3 bucket to offload Open edX file storage.
#------------------------------------------------------------------------------

module "openedx_backup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.6"

  bucket = var.resource_name_backup
  acl    = "private"

  versioning = {
    enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "openedx_backup" {
  bucket = module.openedx_backup.s3_bucket_id

  rule {
    id = "openedx-backup-large-files"

    filter {
      object_size_greater_than = 1000000000
    }

    expiration {
      days = "30"
    }

    status = "Enabled"
  }
}
