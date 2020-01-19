environment = "dev"
region = "eu-west-2"
app_dns_name = ""
app_service_name = "example-go-app"

ecs_cluster_name = "dev-cluster"
ecs_service_task_count = 2
ecs_task_log_group = "/aws/fargate/example-go-app"

### ACM certificates
# Must be in the same region as the app
alb_acm_cert_id = ""
# Must be in us-east-1
cdn_acm_cert_id = ""

### VPC networking
vpc_cidr                  = "10.0.0.0/16"
vpc_public_subnet_ranges  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
vpc_private_subnet_ranges = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
vpc_availability_zones    = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
