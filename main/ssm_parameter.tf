resource "aws_ssm_parameter" "cloudwatch_config" {
  name = "AmazonCloudWatch-linux"
  description = "configuration for cloudwatch agent"
  type = "String"
  value = file("${path.module}/configs/cloudwatch.json")
}