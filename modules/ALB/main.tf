# ------- Random ID for ALB Target Group -------
resource "random_id" "target_group" {
  byte_length = 4
}

resource "aws_alb" "alb" {
  count              = var.create_alb == true ? 1 : 0
  name               = "alb-${var.name}"
  subnets            = [var.subnets[0], var.subnets[1]]
  security_groups    = [var.security_group]
  load_balancer_type = "application"
  internal           = false
  enable_http2       = true
  idle_timeout       = 30
}

resource "aws_alb_target_group" "target_group" {
  count                = var.create_target_group == true ? 1 : 0
  name                 = "${var.name}-${random_id.target_group.hex}"
  port                 = var.port
  protocol             = var.protocol
  vpc_id               = var.vpc
  target_type          = var.tg_type
  deregistration_delay = 5

  health_check {
    enabled             = true
    interval            = 15
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.protocol
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "http_listener" {
  count             = var.create_alb == true ? 1 : 0
  load_balancer_arn = aws_alb.alb[0].id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group[0].arn
    type             = "forward"
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}
