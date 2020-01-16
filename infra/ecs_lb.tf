resource "aws_lb" "alb" {
  name               = var.ecs_cluster_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets.*.id
}
resource "aws_lb_target_group" "tg" {
  name_prefix = var.ecs_service_name
  port      = 5000
  protocol  = "HTTP"
  vpc_id    = aws_vpc.primary.id
  target_type = "ip"
  lifecycle {
    create_before_destroy = true
  }
  deregistration_delay = 10
}
resource "aws_lb_listener" "fe" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_cert_id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
