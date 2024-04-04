resource "aws_ecr_repository" "ecr_registries" {
  count = length(var.ecr_registries)
  name  = var.ecr_registries[count.index]
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_registries_policies" {
  count      = length(var.ecr_registries)
  depends_on = [
    aws_ecr_repository.ecr_registries
  ]

  repository = var.ecr_registries[count.index]
  policy     = file("${path.module}/resources/default-lifecycle-policy.json")
}