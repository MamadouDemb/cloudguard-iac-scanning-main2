variable "aws_region" {
  description = "AWS region used by aws provider"
  type        = string
}

variable "aws_access_id" {
  description = " AWS account access key id"
  type        = string
  sensitive   = true
}
variable "aws_secret_key" {
  description = " AWS account secret access key"
  type        = string
  sensitive   = true
}