# Webserver Security group
resource "aws_security_group" "webserver_sg" {
  name_prefix = "${var.environment}-webserver-sg"
  description = "Allow all inbound traffic from port 22 and 80"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = format("%s-webserver-security-group", var.environment)
    Environment = var.environment
    Owner       = var.owner
    "Manage by" : "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "webserver_allow_all_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "webserver_allow_all_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "webserver_allow_all_ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "webserver_allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver_sg.id
}
