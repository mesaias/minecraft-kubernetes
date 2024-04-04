resource "aws_cloudtrail" "minecraft" {
  depends_on = [aws_s3_bucket_policy.minecraft-cloudtrail]

  name                          = "${var.application_name}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.minecraft-cloudtrail.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "minecraft-cloudtrail" {
  bucket        = "${var.application_name}-cloudtrail"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "minecraft-cloudtrail" {
  bucket = aws_s3_bucket.minecraft-cloudtrail.id
  policy = data.aws_iam_policy_document.minecraft-cloudtrail.json
}