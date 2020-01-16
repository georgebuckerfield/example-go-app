locals {
  container_definition = {
    name         = "goapp"
    image        =  "docker.io/georgebuckerfield/example-go-app:latest"
    essential    = true
    portMappings = [
      {
        containerPort  = 5000
        protocol       =  "tcp"
      }
    ]
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
  family = var.ecs_service_name
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu =  256
  memory = 512
  execution_role_arn = aws_iam_role.task_execution_role.arn
  container_definitions = "[${local.container_json}]"
}
