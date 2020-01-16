resource "aws_cloudwatch_log_group" "app" {
  name = var.ecs_task_log_group
}
