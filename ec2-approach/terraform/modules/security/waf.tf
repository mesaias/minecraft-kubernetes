resource "aws_wafv2_web_acl" "minecraft_acl" {
  name        = "minecraft-web-acl"
  description = "minecraft Web Application Firewall ACL"

  default_action {
    block {}
  }

  rule {
    name     = "minecraft_rule"
    priority = 1

    action {
      block {}
    }

    statement {
      rule_group_reference_statement {
        arn = "arn:aws:wafv2:us-east-1:123456789012:regional/rulegroup/minecraft-rule-group"
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "MinecraftRuleMetrics" 
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "MinecraftWebACLMetrics"
  }
}

resource "aws_wafv2_web_acl_association" "minecraft_acl_association" {
  resource_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/minecraft/abcdef1234567890"
  web_acl_arn  = aws_wafv2_web_acl.example_acl.arn
}