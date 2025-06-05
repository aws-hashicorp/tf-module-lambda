# GLOBAL VARIABLES
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}

# --- Lambda Variables ---
variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "lambda_function"
}

variable "lambda_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "nodejs14.x"
}

# --- Security Group Variables ---
variable "allowed_cidrs" {
  description = "The CIDR blocks to allow"
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "The security groups to allow"
  type        = list(string)
  default     = []
}

variable "allowed_prefix_list_ids" {
  description = "The prefix list IDs to allow"
  type        = list(string)
  default     = []
}

variable "sg_listener_port_from" {
  description = "The starting port for the security group listener"
  type        = number
  default     = 80
}

variable "sg_listener_port_to" {
  description = "The ending port for the security group listener"
  type        = number
  default     = 80
}

variable "sg_listener_protocol" {
  description = "The protocol for the security group listener"
  type        = string
  default     = "tcp"
}

# --- IAM Role Variables ---
variable "permissions_name" {
  description = "List name of policies for role"
  type        = list(string)
  default     = []
}

# CloudWatch Logs Variables
variable "log_group_retention" {
  description = "The retention period (in days) for the CloudWatch log group"
  type        = number
}
