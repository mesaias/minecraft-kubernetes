resource "aws_iam_role" "replication_s3" {
  name               = "${var.s3_replication_role_name}_${terraform.workspace}"
  assume_role_policy = file("${path.module}/policies_json/replication_s3.json")
}