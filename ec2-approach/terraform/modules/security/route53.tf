resource "aws_route53_zone" "minecraft" {
  name = "minecraft-server-isaias.com"
}

resource "aws_route53_record" "example_record" {
  zone_id = aws_route53_zone.minecraft.zone_id
  name    = "minecraft-server-isaias.com"
  type    = "A"
  alias {
    name                   = "minecraft-domain.us-east-1.elb.amazonaws.com"  # Specify the DNS name of your ALB
    zone_id                = aws_route53_zone.minecraft.zone_id
    evaluate_target_health = true
  }
}