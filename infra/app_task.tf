locals {
  container_definition = {
    name         = "goapp"
    image        =  var.app_docker_image
    cpu = 0
    essential    = true
    environment  = []
    mountPoints  = []
    portMappings = [
      {
        containerPort  = 5000
        hostPort       = 5000
        protocol       =  "tcp"
      }
    ]
    volumesFrom      = []
    logConfiguration = {
      logDriver =  "awslogs"
      options =  {
        awslogs-group         = var.ecs_task_log_group
        awslogs-stream-prefix = var.environment
        awslogs-region        =  var.region
      }
    }
  }
  container_json = jsonencode(local.container_definition)
}

resource "aws_ecs_task_definition" "goapp" {
  family = var.app_service_name
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu =  256
  memory = 512
  execution_role_arn = aws_iam_role.task_execution_role.arn
  container_definitions = "[${local.container_json}]"
}
