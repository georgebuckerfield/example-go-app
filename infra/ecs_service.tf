resource "aws_ecs_cluster" "primary" {
  name = var.ecs_cluster_name
}
resource "aws_ecs_service" "goapp" {
  name        = var.ecs_service_name
  cluster     = var.ecs_cluster_name
  launch_type = "FARGATE"
  network_configuration {
    subnets = aws_subnet.private_subnets.*.id
    security_groups = [aws_security_group.ecs_sg.id]
  }

  task_definition = aws_ecs_task_definition.goapp.arn
  desired_count   = var.ecs_service_task_count

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.id
    container_name   = "goapp"
    container_port   = 5000
  }

  # Ignore changes in count from autoscaling actions
  lifecycle {
    ignore_changes = [desired_count]
  }
}
