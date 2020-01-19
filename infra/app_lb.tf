resource "aws_lb" "alb" {
  name               = var.ecs_cluster_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets.*.id
  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    enabled = true
  }
}
resource "aws_lb_target_group" "tg" {
  name_prefix = var.app_service_name
  port      = 5000
  protocol  = "HTTP"
  vpc_id    = aws_vpc.primary.id
  target_type = "ip"
  lifecycle {
    create_before_destroy = true
  }
  deregistration_delay = 10
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_acm_cert_id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
