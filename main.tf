# Security Group
resource "aws_security_group" "lambda_service" {
  name   = "${var.lambda_function_name}-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidrs != null && length(var.allowed_cidrs) > 0 ? [1] : []
    content {
      from_port   = var.sg_listener_port_from
      to_port     = var.sg_listener_port_to
      protocol    = var.sg_listener_protocol
      cidr_blocks = var.allowed_cidrs
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_security_groups != null && length(var.allowed_security_groups) > 0 ? [1] : []
    content {
      from_port       = var.sg_listener_port_from
      to_port         = var.sg_listener_port_to
      protocol        = var.sg_listener_protocol
      security_groups = var.allowed_security_groups
      description     = "Allow from security groups"
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_prefix_list_ids != null && length(var.allowed_prefix_list_ids) > 0 ? [1] : []
    content {
      from_port       = var.sg_listener_port_from
      to_port         = var.sg_listener_port_to
      protocol        = var.sg_listener_protocol
      prefix_list_ids = var.allowed_prefix_list_ids
      description     = "Allow from prefix lists"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.lambda_function_name}-sg" })
}

# IAM Role
resource "aws_iam_role" "iam_lambda_role" {
  name               = "lambdaRole-${var.lambda_function_name}"
  assume_role_policy = file("${path.module}/policies/ecs-trusted_policy.json")

  tags = var.tags
}

# Attach Policies
resource "aws_iam_role_policy_attachment" "role_policy_attach" {
  role       = aws_iam_role.iam_lambda_role.name
  count      = length(var.permissions_name)
  policy_arn = element(data.aws_iam_policy.role_permissions_data.*.id, count.index)
}

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  runtime       = var.lambda_runtime
  role          = aws_iam_role.iam_lambda_role.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_service.id]
  }

  tags = var.tags
}
